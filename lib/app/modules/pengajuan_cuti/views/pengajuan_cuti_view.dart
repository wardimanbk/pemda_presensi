import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/pengajuan_cuti_controller.dart';

class PengajuanCutiView extends GetView<PengajuanCutiController> {
  const PengajuanCutiView({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final Color primaryColor = const Color(0xFF137FEC);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
      appBar: _buildAppBar(isDark),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Jenis Cuti"),
                _buildDropdown(isDark, primaryColor),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(child: _buildDatePicker("Tanggal Mulai", controller.startDate, true, context, isDark)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDatePicker("Tanggal Selesai", controller.endDate, false, context, isDark)),
                  ],
                ),
                const SizedBox(height: 24),
                
                _buildDurationBanner(primaryColor),
                const SizedBox(height: 24),
                
                _buildLabel("Alasan"),
                _buildTextArea(isDark, primaryColor),
                const SizedBox(height: 24),
                
                _buildLabel("Dokumen Pendukung"),
                _buildCameraUpload(isDark, primaryColor),
              ],
            ),
          ),
          _buildBottomButton(primaryColor, isDark),
        ],
      ),
    );
  }

  // --- Widgets ---

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Text("Pengajuan Cuti", 
        style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      centerTitle: true,
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildDropdown(bool isDark, Color primary) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text("Pilih jenis cuti"),
          value: controller.selectedLeaveType.value.isEmpty ? null : controller.selectedLeaveType.value,
          items: controller.leaveTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) => controller.selectedLeaveType.value = val!,
        ),
      ),
    ));
  }

  Widget _buildDatePicker(String label, Rxn<DateTime> dateObs, bool isStart, BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        GestureDetector(
          onTap: () => controller.pickDate(context, isStart),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  dateObs.value == null ? "DD/MM/YYYY" : DateFormat('dd/MM/yyyy').format(dateObs.value!),
                  style: TextStyle(color: dateObs.value == null ? Colors.grey : null),
                )),
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationBanner(Color primary) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, size: 20, color: primary),
          const SizedBox(width: 8),
          Text("Total Cuti: ", style: TextStyle(color: primary, fontWeight: FontWeight.w500)),
          Text("${controller.totalDays} Hari", style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
        ],
      ),
    ));
  }

  Widget _buildTextArea(bool isDark, Color primary) {
    return Column(
      children: [
        TextField(
          controller: controller.reasonController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Tuliskan alasan lengkap pengajuan cuti anda...",
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primary),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Obx(() => Text("${controller.reasonLength.value}/500 karakter", 
            style: const TextStyle(fontSize: 12, color: Colors.grey))),
        ),
      ],
    );
  }

  Widget _buildCameraUpload(bool isDark, Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("(Wajib untuk Cuti Sakit)", style: TextStyle(color: Colors.red, fontSize: 11)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {}, // Logika kamera
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? Colors.white10 : Colors.black12, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: primary.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.photo_camera, size: 32, color: primary),
                ),
                const SizedBox(height: 12),
                const Text("Ambil Foto", style: TextStyle(fontWeight: FontWeight.bold)),
                const Text("Gunakan kamera langsung", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(Color primary, bool isDark) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF101922).withOpacity(0.9) : Colors.white.withOpacity(0.9),
          border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
        ),
        child: ElevatedButton(
          onPressed: controller.submitRequest,
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 8,
            shadowColor: primary.withOpacity(0.4),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("AJUKAN CUTI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(width: 8),
              Icon(Icons.send, size: 20, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
