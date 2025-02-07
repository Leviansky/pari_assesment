// ignore_for_file: unnecessary_overrides, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pari_testapp/app/core/utils/error_connection.dart';
import 'package:pari_testapp/app/core/values/delay.dart';
import 'package:pari_testapp/app/data/models/item_model.dart';
import 'package:pari_testapp/app/data/providers/item_provider.dart';
import 'package:pari_testapp/app/routes/app_pages.dart';

class Mode {
  static const CREATE = "create";
  static const UPDATE = "update";
}

class CreateUpdateController extends GetxController {
  final String? id = Get.arguments;
  final provider = ItemProvider();
  final mode = ''.obs;
  final isLoading = false.obs;
  Rx<ItemModel> item = ItemModel().obs;

  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final priceController = TextEditingController();
  final cpuModelController = TextEditingController();
  final hardDiskSizeController = TextEditingController();
  final colorController = TextEditingController();
  final capacityController = TextEditingController();
  final screenSizeController = TextEditingController();

  final nameError = ''.obs;

  void checkMode() {
    if (id == null) {
      mode.value = Mode.CREATE;
    } else {
      mode.value = Mode.UPDATE;
      fetchItem();
    }
  }

  void fetchItem() async {
    try {
      isLoading(true);
      await provider
          .getItem(id!)
          .timeout(
            DelayConstants.timeout,
            onTimeout: _handleTimeout,
          )
          .then((fetchedItems) {
        if (fetchedItems != null) {
          item.value = fetchedItems;

          nameController.text = item.value.name ?? "";
          yearController.text = item.value.data?.year?.toString() ?? "";
          priceController.text = item.value.data?.price?.toString() ?? "";
          cpuModelController.text = item.value.data?.cpuModel ?? "";
          hardDiskSizeController.text =
              item.value.data?.hardDiskSize?.toString() ?? "";
          colorController.text = item.value.data?.color ?? "";
          capacityController.text = item.value.data?.capacity?.toString() ?? "";
          screenSizeController.text =
              item.value.data?.screenSize?.toString() ?? "";
        }
      });
    } catch (e) {
      AlertMessageWithButton(
        title: "Error",
        message: "Error connecting to the server, please try again.",
        confirmText: "Try again",
        onConfirm: () {
          Get.back();
          checkMode();
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

  Null _handleTimeout() {
    isLoading(false);
    Timeout().dialog();
    return null;
  }

  void executeButton() {
    if (mode.value == Mode.CREATE) {
      createProduct();
    } else {
      updateProduct();
    }
  }

  void createProduct() async {
    try {
      isLoading(true);
      if (!_validateInputs()) return;
      var bodyRequest = createNewModel();
      await provider
          .createItem(bodyRequest)
          .timeout(
            DelayConstants.timeout,
            onTimeout: _handleTimeout,
          )
          .then((response) {
        print(response);
        Get.offAllNamed(Routes.HOME);
      });
    } catch (e) {
      ErrorConnection().dialog();
    } finally {
      isLoading(false);
    }
  }

  void updateProduct() async {
    try {
      isLoading(true);
      if (!_validateInputs()) return;
      var bodyRequest = createNewModel();
      await provider
          .updateItem(id!, bodyRequest)
          .timeout(
            DelayConstants.timeout,
            onTimeout: _handleTimeout,
          )
          .then((response) {
        Get.offAllNamed(Routes.HOME);
      });
    } catch (e) {
      ErrorConnection().dialog();
    } finally {
      isLoading(false);
    }
  }

  bool _validateInputs() {
    if (nameController.text == "") {
      nameError.value = "Name required to input";
      return false;
    }
    nameError.value = "";
    return true;
  }

  Map<String, dynamic> createNewModel() {
    final Map<String, dynamic> data = {};
    final Map<String, dynamic> itemData = {};

    if (nameController.text.trim().isNotEmpty) {
      data['name'] = nameController.text.trim();
    }

    if (yearController.text.trim().isNotEmpty) {
      final year = int.tryParse(yearController.text.trim());
      if (year != null) itemData['year'] = year;
    }

    if (priceController.text.trim().isNotEmpty) {
      final price = double.tryParse(priceController.text.trim());
      if (price != null) itemData['price'] = price;
    }

    if (cpuModelController.text.trim().isNotEmpty) {
      itemData['cpuModel'] = cpuModelController.text.trim();
    }

    if (hardDiskSizeController.text.trim().isNotEmpty) {
      itemData['hardDiskSize'] = hardDiskSizeController.text.trim();
    }

    if (colorController.text.trim().isNotEmpty) {
      itemData['color'] = colorController.text.trim();
    }

    if (capacityController.text.trim().isNotEmpty) {
      itemData['capacity'] = capacityController.text.trim();
    }

    if (screenSizeController.text.trim().isNotEmpty) {
      final screenSize = double.tryParse(screenSizeController.text.trim());
      if (screenSize != null) itemData['screenSize'] = screenSize;
    }

    data['name'] = nameController.text.trim();
    data['data'] = itemData;

    return data;
  }

  @override
  void onInit() {
    checkMode();
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
