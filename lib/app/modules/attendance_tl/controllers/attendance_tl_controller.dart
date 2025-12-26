import 'package:get/get.dart';
import 'dart:async';

class AttendanceTlController extends GetxController {
  // Observables untuk data SPT
  final sptNumber = "No. 800/123/BKPSDM/2023".obs;
  final sptType = "Dinas Luar - Inspektorat Daerah".obs;
  final sptDateRange = "24 - 26 Oct 2023".obs;
  final duration = "3 Days".obs;

  // Observables untuk Lokasi
  final currentAddress = "Jalan Jenderal Sudirman No. 45, Jakarta Pusat".obs;
  final coordinates = "-6.2088° S, 106.8456° E".obs;
  final accuracy = "± 5m".obs;
  final isInZone = true.obs;

  // Status Kamera
  final isFlashOn = false.obs;

  void toggleFlash() => isFlashOn.value = !isFlashOn.value;
  
  void switchCamera() {
    // Logika ganti kamera depan/belakang
  }

  void captureAttendance() {
    // Logika ambil foto dan simpan data
    Get.snackbar("Success", "Absensi Tugas Luar berhasil diambil");
  }

  void onBack() => Get.back();
  void onHelp() => print("Help clicked");
}
