import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PengajuanCutiController extends GetxController {
  // Observables
  final selectedLeaveType = "".obs;
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final reasonController = TextEditingController();
  final reasonLength = 0.obs;

  // List jenis cuti
  final List<String> leaveTypes = [
    "Cuti Tahunan",
    "Cuti Sakit",
    "Cuti Tanpa Gaji (Unpaid)",
    "Cuti Melahirkan"
  ];

  @override
  void onInit() {
    super.onInit();
    reasonController.addListener(() {
      reasonLength.value = reasonController.text.length;
    });
  }

  // Hitung selisih hari
  int get totalDays {
    if (startDate.value != null && endDate.value != null) {
      return endDate.value!.difference(startDate.value!).inDays + 1;
    }
    return 0;
  }

  Future<void> pickDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      if (isStart) {
        startDate.value = picked;
      } else {
        endDate.value = picked;
      }
    }
  }

  void submitRequest() {
    // Logika pengajuan
    Get.snackbar(
      "Berhasil", 
      "Permohonan cuti Anda telah dikirim",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
