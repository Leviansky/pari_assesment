import 'dart:convert';

import 'package:get/get.dart';
import 'package:pari_testapp/app/core/values/api.dart';
import '../models/item_model.dart';

class ItemProvider extends GetConnect {
  final api = Api.baseUrl;

  @override
  void onInit() {
    httpClient.baseUrl = api;
    super.onInit();
  }

  Future<List<ItemModel>> getItems() async {
    final response = await get('$api/objects');
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    }
    return (response.body as List)
        .map((item) => ItemModel.fromJson(item))
        .toList();
  }

  Future getItem(String id) async {
    final response = await get('$api/objects/$id');
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    }
    return ItemModel.fromJson(response.body);
  }

  Future createItem(Map<String, dynamic> item) async {
    final response = await post('$api/objects', jsonEncode(item));
    return response.body;
  }

  Future updateItem(String id, Map<String, dynamic> item) async {
    final response = await put('$api/objects/$id', jsonEncode(item));
    return response.body;
  }

  Future deleteItem(String id) async {
    final response = await delete('$api/objects/$id');
    return response.body;
  }
}