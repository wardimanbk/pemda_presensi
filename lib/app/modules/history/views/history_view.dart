import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final Color surfaceColor = isDark ? const Color(0xFF15202B) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
      appBar: _buildAppBar(isDark),
      body: Column(
        children: [
          _buildMonthNavigation(isDark),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildCalendarGrid(isDark),
                  const SizedBox(height: 16),
                  _buildLegendScroll(),
                  const SizedBox(height: 24),
                  _buildSummaryCard(isDark, surfaceColor),
                  const SizedBox(height: 24),
                  _buildDailyDetail(isDark, surfaceColor),
                  const SizedBox(height: 100), // Padding bawah
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- App Bar ---
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Text("Riwayat Kehadiran",
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      centerTitle: true,
      actions: [
        IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
      ),
    );
  }

  // --- Month Navigation ---
  Widget _buildMonthNavigation(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: controller.prevMonth, icon: const Icon(Icons.chevron_left)),
          Obx(() => Text(controller.selectedMonth.value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          IconButton(onPressed: controller.nextMonth, icon: const Icon(Icons.chevron_right)),
        ],
      ),
    );
  }

  // --- Calendar Grid ---
  Widget _buildCalendarGrid(bool isDark) {
    const weekDays = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays.map((d) => Text(d, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12))).toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 4),
          itemCount: 30 + 4, // 30 hari + offset 4 hari awal
          itemBuilder: (context, index) {
            if (index < 4) return const SizedBox(); // Offset kosong
            int day = index - 3;
            return Obx(() {
              bool isSelected = controller.selectedDay.value == day;
              int? status = controller.attendanceStatus[day];
              return GestureDetector(
                onTap: () => controller.selectDay(day),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _getCalendarBgColor(status, isDark),
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: const Color(0xFF137FEC), width: 2) : null,
                  ),
                  child: Text(
                    "$day",
                    style: TextStyle(
                      color: _getCalendarTextColor(status, isDark),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ],
    );
  }

  // --- Legend ---
  Widget _buildLegendScroll() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _legendChip("Tepat Waktu", Colors.green),
          _legendChip("Terlambat", Colors.yellow),
          _legendChip("Alpa", Colors.red),
          _legendChip("Cuti/Izin", Colors.purple),
          _legendChip("Tugas Luar", Colors.teal),
          _legendChip("Libur", Colors.grey),
        ],
      ),
    );
  }

  Widget _legendChip(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- Summary Card ---
  Widget _buildSummaryCard(bool isDark, Color surface) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ringkasan Bulan Ini", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryItem("Total Hadir", "${controller.totalHadir.value} Hari", Colors.grey),
              _summaryItem("Terlambat", "${controller.totalTerlambat.value} Min", Colors.yellow),
              _summaryItem("Alpa", "${controller.totalAlpa.value}", Colors.red),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Estimasi TPP", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text("Perkiraan pendapatan", style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              Obx(() => Text("Rp ${controller.estimasiTPP.value}",
                  style: const TextStyle(color: Color(0xFF137FEC), fontSize: 20, fontWeight: FontWeight.bold))),
            ],
          )
        ],
      ),
    );
  }

  // --- Daily Detail ---
  Widget _buildDailyDetail(bool isDark, Color surface) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Text("Rabu, ${controller.selectedDay.value} September", style: const TextStyle(fontWeight: FontWeight.bold))),
            const Text("Detail Harian", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: const Border(left: BorderSide(color: Colors.green, width: 4)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hadir Tepat Waktu", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("08:00 - 16:00 WIB", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                    child: const Text("VERIFIED", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  _timeDetail("MASUK", "07:55 AM", "Kantor Pusat", Icons.login),
                  const SizedBox(width: 16),
                  _timeDetail("PULANG", "16:05 PM", "Kantor Pusat", Icons.logout),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets ---
  Widget _summaryItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: valueColor == Colors.grey ? null : valueColor)),
      ],
    );
  }

  Widget _timeDetail(String label, String time, String loc, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          Text(loc, style: const TextStyle(fontSize: 11, color: Colors.grey), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Color _getCalendarBgColor(int? status, bool isDark) {
    switch (status) {
      case 1: return Colors.green.withOpacity(isDark ? 0.3 : 0.1);
      case 2: return Colors.grey.withOpacity(isDark ? 0.2 : 0.1);
      case 3: return Colors.yellow.withOpacity(isDark ? 0.3 : 0.1);
      case 4: return Colors.teal.withOpacity(isDark ? 0.3 : 0.1);
      case 5: return Colors.red.withOpacity(isDark ? 0.3 : 0.1);
      case 6: return Colors.purple.withOpacity(isDark ? 0.3 : 0.1);
      default: return Colors.transparent;
    }
  }

  Color _getCalendarTextColor(int? status, bool isDark) {
    switch (status) {
      case 1: return Colors.green;
      case 2: return Colors.grey;
      case 3: return Colors.orange;
      case 4: return Colors.teal;
      case 5: return Colors.red;
      case 6: return Colors.purple;
      default: return isDark ? Colors.white : Colors.black;
    }
  }
}
