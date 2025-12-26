import 'package:get/get.dart';

class HomeController extends GetxController {
  // Data dummy untuk UI
  final userName = "Budi Santoso".obs;
  final nip = "19820312 201001 1 005".obs;
  final isInRange = true.obs;
  final tppPerformance = 0.95.obs; // 95%
  
  // Status Absensi
  final checkInTime = "07:15".obs;
  final checkOutTime = "--:--".obs;
  final statusDate = "Senin, 24 Oktober 2023".obs;

  void onNotificationPressed() => print("Notifikasi ditekan");
  void onScanQR() => print("Membuka Scanner QR");
}
