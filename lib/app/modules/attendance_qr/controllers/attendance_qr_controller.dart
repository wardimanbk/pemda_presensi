import 'package:get/get.dart';

class AttendanceQrController extends GetxController {
  // Status Senter
  final isFlashOn = false.obs;
  
  // Data Event (Mock)
  final eventName = "Apel Pagi Rutin".obs;
  final eventTime = "07:30 WIB".obs;
  final eventLocation = "Halaman Kantor Gubernur".obs;

  void toggleFlash() {
    isFlashOn.value = !isFlashOn.value;
    // Integrasi dengan library camera/mobile_scanner di sini
  }

  void onBack() {
    Get.back();
  }
}
