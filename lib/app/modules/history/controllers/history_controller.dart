import 'package:get/get.dart';

class HistoryController extends GetxController {
  // Observables
  final selectedMonth = "September 2023".obs;
  final selectedDay = 13.obs;
  final totalHadir = 12.obs;
  final totalTerlambat = 45.obs; // dalam menit
  final totalAlpa = 1.obs;
  final estimasiTPP = "3.500.000".obs;

  // Mock Data Status (1: Hadir, 2: Libur, 3: Terlambat, 4: Tugas Luar, 5: Alpa, 6: Cuti)
  final Map<int, int> attendanceStatus = {
    1: 1, 2: 2, 3: 2, 4: 1, 5: 3, 6: 1, 7: 4, 8: 1, 9: 2, 10: 2, 11: 5, 12: 6, 13: 1, 14: 1, 15: 3, 16: 2, 17: 2, 18: 1
  };

  void selectDay(int day) => selectedDay.value = day;
  void nextMonth() => print("Next Month");
  void prevMonth() => print("Prev Month");
}
