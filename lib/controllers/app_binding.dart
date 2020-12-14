import 'package:get/get.dart';

import 'auth_controller.dart';

// Get.lazyPut loads dependencies only one time, which means that if the route gets removed, and created again, Get.lazyPut will not load them again so we use the fenix property.
class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}
