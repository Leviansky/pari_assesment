import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pari_testapp/app/core/utils/error_connection.dart';
import 'package:pari_testapp/app/core/values/delay.dart';
import 'package:pari_testapp/app/data/models/item_model.dart';
import 'package:pari_testapp/app/data/providers/item_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController {
  // Dependencies
  final ItemProvider _provider;
  final GetStorage _storage;

  // Controllers
  late final RefreshController refreshController;
  late final TextEditingController searchController;

  // Observable states
  final RxList<ItemModel> _items = <ItemModel>[].obs;
  final RxList<ItemModel> filteredItems = <ItemModel>[].obs;
  final RxBool isLoading = true.obs;

  // Getters
  List<ItemModel> get items => _items;

  // Constructor with dependency injection
  HomeController({
    ItemProvider? provider,
    GetStorage? storage,
  })  : _provider = provider ?? ItemProvider(),
        _storage = storage ?? GetStorage();

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(initialRefresh: false);
    searchController = TextEditingController();
    _initializeData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> _initializeData() async {
    _loadCachedItems();
    if (_shouldFetchFreshData()) {
      print("fetching fresh data");
      await fetchItems();
    }
  }

  bool _shouldFetchFreshData() {
    final lastUpdated = _storage.read<String>('last_updated');
    if (lastUpdated == null) return true;
    final lastUpdateTime = DateTime.parse(lastUpdated);
    final now = DateTime.now();
    return now.isAfter(lastUpdateTime);
  }

  void _loadCachedItems() {
    try {
      final cachedData = _storage.read<String>(DelayConstants.storageKey);
      if (cachedData != null) {
        final List<dynamic> decodedData = json.decode(cachedData);
        final List<ItemModel> cachedItems =
            decodedData.map((item) => ItemModel.fromJson(item)).toList();
        _updateItems(cachedItems);
        isLoading(false);
      }
    } catch (e) {
      AlertMessage(
        title: "Error",
        message: "Error loading cached items: $e",
      );
    }
  }

  Future<void> _cacheItems(List<ItemModel> items) async {
    try {
      final itemsJson =
          json.encode(items.map((item) => item.toJson()).toList());
      await _storage.write(DelayConstants.storageKey, itemsJson);
      await _storage.write('last_updated', DateTime.now().toIso8601String());
    } catch (e) {
      AlertMessage(
        title: "Error",
        message: "Error caching items: $e",
      );
    }
  }

  Future<void> onRefresh() async {
    Timer? refreshTimer;
    final completer = Completer<void>();
    try {
      refreshTimer = Timer.periodic(
        DelayConstants.interval,
        (timer) => _handleRefreshTick(timer, completer),
      );
      await completer.future;
    } catch (error) {
      refreshController.refreshFailed();
      rethrow;
    } finally {
      refreshTimer?.cancel();
      refreshController.refreshCompleted();
    }
  }

  void _handleRefreshTick(Timer timer, Completer<void> completer) {
    if (!refreshController.isRefresh) {
      _completeRefresh(timer, completer);
      return;
    }
    if (timer.tick > DelayConstants.timeout.inSeconds) {
      _handleRefreshTimeout(timer, completer);
      return;
    }
    _performRefresh(completer);
  }

  void _completeRefresh(Timer timer, Completer<void> completer) {
    timer.cancel();
    if (!completer.isCompleted) completer.complete();
  }

  void _handleRefreshTimeout(Timer timer, Completer<void> completer) {
    timer.cancel();
    if (!completer.isCompleted) {
      completer.completeError(
          const DelayTimeoutException('Refresh operation timed out'));
    }
  }

  void _performRefresh(Completer<void> completer) async {
    await fetchItems();
    if (!completer.isCompleted) completer.complete();
  }

  void searchItems(String query) {
    if (query.isEmpty) {
      filteredItems.assignAll(_items);
      return;
    }
    final lowerQuery = query.toLowerCase();
    filteredItems.assignAll(_filterItemsByQuery(lowerQuery));
  }

  List<ItemModel> _filterItemsByQuery(String query) {
    return _items.where((item) {
      final searchableValues = _getSearchableValues(item);
      return searchableValues.any((value) => value.contains(query));
    }).toList();
  }

  List<String> _getSearchableValues(ItemModel item) {
    final data = item.data;
    return [
      item.name,
      data?.year?.toString(),
      data?.price?.toString(),
      data?.cpuModel,
      data?.hardDiskSize,
      data?.screenSize?.toString(),
      data?.capacityGb?.toString(),
      data?.capacity,
      data?.color,
    ].whereType<String>().map((e) => e.toLowerCase()).toList();
  }

  Future<void> fetchItems() async {
    try {
      isLoading(true);
      final fetchedItems = await _provider.getItems().timeout(
            DelayConstants.timeout,
            onTimeout: _handleTimeout,
          );
      await _cacheItems(fetchedItems);
      _updateItems(fetchedItems);
    } catch (e) {
      ErrorConnection().dialog();
    } finally {
      isLoading(false);
    }
  }

  List<ItemModel> _handleTimeout() {
    isLoading(false);
    Timeout().dialog();
    return [];
  }

  void _updateItems(List<ItemModel> fetchedItems) {
    _items.value = fetchedItems;
    final currentSearch = searchController.text;
    if (currentSearch.isEmpty) {
      filteredItems.assignAll(_items);
    } else {
      searchItems(currentSearch);
    }
  }

  void confirmDeleteItem(String id, String name) {
    AlertMessageWithButton(
      title: "Are you sure?",
      message: "Want to delete $name",
      confirmText: "Yes, sure!",
      cancelText: "Cancel",
      onConfirm: () => _deleteItem(id),
      onCancel: Get.back,
      confirmColor: Colors.white,
      cancelColor: Colors.white,
    ).dialog();
  }

  Future<void> _deleteItem(String id) async {
    try {
      await _provider.deleteItem(id);
      Get.back();
      await fetchItems();
    } catch (e) {
      ErrorConnection().dialog();
    }
  }
}
