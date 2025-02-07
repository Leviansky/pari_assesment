import 'package:get/get.dart';

import '../controllers/create_update_controller.dart';

class CreateUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreateUpdateController());
  }
}
