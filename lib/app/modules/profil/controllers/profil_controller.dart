import 'package:get/get.dart';

class ProfilController extends GetxController {
  // Data Profil
  final name = "Dr. Budi Santoso".obs;
  final position = "Kepala Bagian Umum".obs;
  final nip = "19820312 201001 1 005".obs;
  
  // Data Kepegawaian
  final skpd = "Dinas Komunikasi dan Informatika".obs;
  final location = "Kantor Walikota Gedung B".obs;
  final phone = "0812-3456-7890".obs;

  // Settings
  final isBiometricActive = true.obs;

  void toggleBiometric(bool value) => isBiometricActive.value = value;
  
  void onLogout() {
    Get.defaultDialog(
      title: "Keluar",
      middleText: "Apakah anda yakin ingin keluar aplikasi?",
      onConfirm: () => print("Logout logic"),
      textConfirm: "Ya",
      textCancel: "Batal"
    );
  }
}
