import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});
  static const Color primaryColor = Color(0xFF137FEC);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final Color surfaceColor = isDark ? const Color(0xFF15202B) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
      appBar: _buildAppBar(isDark, surfaceColor),
      body: SafeArea(
        child: Column(
          children: [
            _buildLocationCard(isDark, surfaceColor),
            _buildDigitalClock(isDark),
            Expanded(child: _buildCameraPreview(isDark)),
            _buildBottomControls(isDark),
          ],
        ),
      ),
    );
  }

  // --- App Bar ---
  PreferredSizeWidget _buildAppBar(bool isDark, Color surface) {
    return AppBar(
      backgroundColor: surface,
      elevation: 0.5,
      leading: IconButton(
        icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Absen Masuk",
        style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(Icons.wifi_off, color: Colors.grey, size: 20),
        )
      ],
      centerTitle: true,
    );
  }

  // --- Location Status Card ---
  Widget _buildLocationCard(bool isDark, Color surface) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 6),
                    Text("LOKASI VALID", style: TextStyle(color: Colors.green[600], fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Obx(() => Text(controller.officeName.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Obx(() => Text("Di dalam Radius (${controller.radius.value})", style: TextStyle(color: Colors.grey[500], fontSize: 13))),
              ],
            ),
          ),
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(image: NetworkImage("https://via.placeholder.com/150"), fit: BoxFit.cover),
            ),
            child: const Center(child: Icon(Icons.location_on, color: primaryColor, size: 24)),
          )
        ],
      ),
    );
  }

  // --- Digital Clock ---
  Widget _buildDigitalClock(bool isDark) {
    return Column(
      children: [
        Obx(() => RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: controller.currentTime.value,
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black, fontFamily: 'monospace'),
              ),
              const TextSpan(text: "  "),
              TextSpan(text: "WIB", style: TextStyle(fontSize: 18, color: Colors.grey[500], fontWeight: FontWeight.w500)),
            ],
          ),
        )),
        Obx(() => Text(controller.currentDate.value, style: TextStyle(color: Colors.grey[500], fontSize: 14))),
        const SizedBox(height: 20),
      ],
    );
  }

  // --- Camera Preview with Scanning Animation ---
  Widget _buildCameraPreview(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: isDark ? Colors.white10 : Colors.white, width: 6),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)],
            color: Colors.grey[900],
          ),
          child: Stack(
            children: [
              // Scanning Line Animation
              const _ScanningLine(),
              // Face Guide Corners
              _buildFaceGuide(),
              // Verification Status Badge
              Positioned(
                bottom: 24, left: 0, right: 0,
                child: Center(
                  child: Container(
                    //padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    //decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                    // child: const Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor)),
                    //     SizedBox(width: 10),
                    //     Text("Sedang memverifikasi...", style: TextStyle(color: Colors.white, fontSize: 12)),
                    //   ],
                    // ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaceGuide() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            _guideCorner(top: 0, left: 0, isTop: true, isLeft: true),
            _guideCorner(top: 0, right: 0, isTop: true, isLeft: false),
            _guideCorner(bottom: 0, left: 0, isTop: false, isLeft: true),
            _guideCorner(bottom: 0, right: 0, isTop: false, isLeft: false),
          ],
        ),
      ),
    );
  }

  Widget _guideCorner({double? top, double? bottom, double? left, double? right, required bool isTop, required bool isLeft}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: 20, height: 20,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? const BorderSide(color: primaryColor, width: 4) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: primaryColor, width: 4) : BorderSide.none,
            left: isLeft ? const BorderSide(color: primaryColor, width: 4) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: primaryColor, width: 4) : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: isTop && isLeft ? const Radius.circular(8) : Radius.zero,
            topRight: isTop && !isLeft ? const Radius.circular(8) : Radius.zero,
            bottomLeft: !isTop && isLeft ? const Radius.circular(8) : Radius.zero,
            bottomRight: !isTop && !isLeft ? const Radius.circular(8) : Radius.zero,
          ),
        ),
      ),
    );
  }

  // --- Bottom Controls ---
  Widget _buildBottomControls(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Text("Posisikan wajah Anda di dalam bingkai", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text("Mohon kedip mata untuk memastikan keaslian", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _iconButton(Icons.cameraswitch, "Kamera", controller.switchCamera),
              // Main Capture Button
              GestureDetector(
                onTap: () => controller.processAttendance(),
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
                  ),
                  child: const Icon(Icons.face, color: Colors.white, size: 40),
                ),
              ),
              _iconButton(Icons.fingerprint, "Sidik Jari", controller.toggleBiometric),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(onPressed: () {}, child: const Text("Butuh bantuan?", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Colors.black12, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ScanningLine extends StatefulWidget {
  const _ScanningLine();
  @override
  State<_ScanningLine> createState() => _ScanningLineState();
}

class _ScanningLineState extends State<_ScanningLine> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          top: _animationController.value * 300, // Menyesuaikan tinggi preview
          left: 0, right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: AttendanceView.primaryColor.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
              gradient: LinearGradient(
                colors: [Colors.transparent, AttendanceView.primaryColor.withOpacity(0.8), Colors.transparent],
              ),
            ),
          ),
        );
      },
    );
  }
}