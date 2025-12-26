import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../views/success_modal_widget_view.dart';

class AttendanceController extends GetxController {
  // Observables
  final currentTime = "".obs;
  final currentDate = "Kamis, 12 Oktober 2023".obs;
  final isVerifying = true.obs;
  final officeName = "Kantor Dinas XYZ".obs;
  final officeDetail = "Gedung B, Lt. 2".obs;
  final radius = "15m".obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startClock();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      // Format: HH:mm:ss
      currentTime.value = 
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    });
  }

  void toggleBiometric() {
    // Logika pindah ke Sidik Jari
    print("Switch to Fingerprint");
  }

  void switchCamera() {
    print("Switching Camera...");
  }

  void processAttendance() async {
    // Simulasi loading verifikasi
    await Future.delayed(const Duration(seconds: 2));
    
    // Tampilkan Modal Sukses
    showSuccessModal();
  }

  void showSuccessModal() {
    Get.dialog(
      const SuccessModalWidgetView(),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
