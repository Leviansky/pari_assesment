// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pari_testapp/app/core/utils/error_connection.dart';
import 'package:pari_testapp/app/core/values/delay.dart';
import 'package:pari_testapp/app/data/models/item_model.dart';
import 'package:pari_testapp/app/data/providers/item_provider.dart';

class DetailController extends GetxController {
  // Dependencies
  final provider = ItemProvider();
  final String id = Get.arguments;
  
  // Observable states
  Rx<ItemModel> item = ItemModel().obs;
  var isLoading = true.obs;

  // Setters
  void _setItem(ItemModel value) {
    item.value = value;
  }

  void fetchItem() async {
    try {
      isLoading(true);
      await provider.getItem(id).timeout(
        DelayConstants.timeout,
        onTimeout: _handleTimeout,
      ).then((fetchedItem) {
        _setItem(fetchedItem); 
      });
    } catch (e) {
      AlertMessageWithButton(
        title: "Error",
        message: "Error connecting to the server, please try again.",
        confirmText: "Try again",
        onConfirm: () {
          Get.back();
          fetchItem();
        },
        cancelText: "Back",
        onCancel: () => Get.close(2),
        confirmColor: Colors.white,
        cancelColor: Colors.white,
      ).dialog();
    } finally {
      isLoading(false);
    }
  }

  ItemModel _handleTimeout() {
    isLoading(false);
    Timeout().dialog();
    return ItemModel();
  }
  
  @override
  void onInit() {
    fetchItem();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
