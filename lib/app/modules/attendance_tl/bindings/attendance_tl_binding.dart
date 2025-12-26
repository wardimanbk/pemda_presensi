import 'package:get/get.dart';

import '../controllers/attendance_tl_controller.dart';

class AttendanceTlBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceTlController>(
      () => AttendanceTlController(),
    );
  }
}
