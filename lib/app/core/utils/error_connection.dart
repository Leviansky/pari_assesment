import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract interface class Popup {
  Future<dynamic> dialog();
}

class Timeout implements Popup {
  @override
  Future<dynamic> dialog() {
    return Get.defaultDialog(
      title: "Error",
      middleText: "Request timeout, please try again.",
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("OK"),
      ),
    );
  }
}

class ErrorConnection implements Popup {
  @override
  Future<dynamic> dialog() {
    return Get.defaultDialog(
      title: "Error",
      middleText: "Error connecting to the server, please try again.",
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("OK"),
      ),
    );
  }
}

class AlertMessage implements Popup {
  final String message;
  final String title;

  AlertMessage({
    required this.message,
    required this.title,
  });

  @override
  Future dialog() {
    return Get.defaultDialog(
      title: title,
      middleText: message,
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("OK"),
      ),
    );
  }
}

class AlertMessageWithButton implements Popup {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final Color? cancelColor;

  AlertMessageWithButton({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
    required this.confirmColor,
    required this.cancelColor,
  });

  @override
  Future dialog() {
    return Get.defaultDialog(
      title: title,
      middleText: message,
      confirm: confirmText != null
          ? ElevatedButton(
              onPressed: onConfirm ?? () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor ?? Colors.white,
              ),
              child: Text(confirmText!),
            )
          : null,
      cancel: cancelText != null
          ? ElevatedButton(
              onPressed: onCancel ?? () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: cancelColor,
              ),
              child: Text(cancelText!),
            )
          : null,
      barrierDismissible: false,
    );
  }
}
