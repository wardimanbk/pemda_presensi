import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/attendance_tl_controller.dart';

class AttendanceTlView extends GetView<AttendanceTlController> {
  const AttendanceTlView({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final Color primaryColor = const Color(0xFF137FEC);
    final Color surfaceColor = isDark ? const Color(0xFF15202B) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
      appBar: _buildAppBar(isDark, surfaceColor),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSPTCard(isDark, surfaceColor, primaryColor),
              const SizedBox(height: 20), 
              _buildCameraViewfinder(primaryColor),
              const SizedBox(height: 20), 
              _buildLocationDetails(isDark, surfaceColor, primaryColor),
              const SizedBox(height: 20), 
              _buildDisclaimer(isDark),
            ],
          ),
        ),
      ),
    );
  }

  // --- App Bar ---
  PreferredSizeWidget _buildAppBar(bool isDark, Color surfaceColor) {
    return AppBar(
      backgroundColor: surfaceColor,
      elevation: 0.5,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
        onPressed: controller.onBack,
      ),
      title: Text(
        "Absen Tugas Luar",
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: controller.onHelp,
        )
      ],
    );
  }

  // --- Card: SPT Details ---
  Widget _buildSPTCard(bool isDark, Color surface, Color primary) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: Container(width: 5, color: primary),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("DASAR SURAT (SPT)", 
                      style: TextStyle(color: primary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    _buildBadge("Active", Colors.blue),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() => Text(controller.sptNumber.value, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                Obx(() => Text(controller.sptType.value, 
                  style: TextStyle(color: Colors.grey[500], fontSize: 14))),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),
                Row(
                  children: [
                    _iconInfo(Icons.calendar_month, controller.sptDateRange.value),
                    const SizedBox(width: 20),
                    _iconInfo(Icons.schedule, controller.duration.value),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Camera Viewfinder ---
  Widget _buildCameraViewfinder(Color primary) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15)],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Placeholder for Camera Feed
            Positioned.fill(
              child: Opacity(
                opacity: 0.8,
                child: Image.network("https://via.placeholder.com/400x600", fit: BoxFit.cover),
              ),
            ),
            // Face Guide Overlay
            Center( 
              child: Container(
                width: Get.width * 0.55,
                height: Get.width * 0.70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.elliptical(Get.width * 0.5, Get.width * 0.7)),
                ),
              ),
            ),
            // Helper Text
            Positioned(
              top: 20, left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.face, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text("Position face within frame", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
            // Camera Controls
            Positioned(
              bottom: 24, left: 24, right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleControl(Icons.flash_off, controller.toggleFlash),
                  _buildCaptureButton(primary),
                  _circleControl(Icons.flip_camera_ios, controller.switchCamera),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Location Details ---
  Widget _buildLocationDetails(bool isDark, Color surface, Color primary) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.location_on, color: primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("CURRENT LOCATION", style: TextStyle(color: Colors.grey[500], fontSize: 10, fontWeight: FontWeight.bold)),
                          _buildBadge("Verified", Colors.green),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Obx(() => Text(controller.currentAddress.value, 
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Obx(() => Text(controller.coordinates.value, style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.grey[500]))),
                          const SizedBox(width: 10),
                          Icon(Icons.my_location, size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Obx(() => Text(controller.accuracy.value, style: TextStyle(fontSize: 11, color: Colors.grey[500]))),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // Map Preview
          Container(
            height: 100,
            width: double.infinity,
            color: isDark ? Colors.blueGrey[900] : Colors.blueGrey[50],
            child: Image.network("https://via.placeholder.com/400x100", fit: BoxFit.cover),
          )
        ],
      ),
    );
  }

  Widget _buildDisclaimer(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              "Photo will be automatically watermarked with 24 Oct 2023, 08:30 WIB, Employee Name, and GPS Coordinates for validation purposes.",
              style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // --- Reusable Small Widgets ---
  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _iconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _circleControl(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildCaptureButton(Color primary) {
    return GestureDetector(
      onTap: controller.captureAttendance,
      child: Container(
        width: 64, height: 64,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Container(
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
