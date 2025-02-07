// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:pari_testapp/app/routes/app_pages.dart';

class SplashController extends GetxController {
  void routeToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offNamed(Routes.HOME);
  }

  @override
  void onInit() {
    super.onInit();
    routeToHome();
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
