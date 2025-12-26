import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/attendance_qr_controller.dart';

class AttendanceQrView extends GetView<AttendanceQrController> {
  const AttendanceQrView({super.key});
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Viewfinder (Simulasi dengan Image)
          _buildCameraBackground(),

          // 2. Main UI Layer
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight( // Memaksa Column mengikuti tinggi layar
                      child: Column(
                        children: [ 
                          _buildHeader(),
                          const Spacer(), // Spacer kini akan bekerja
                          _buildScannerArea(),
                          const Spacer(),
                          _buildBottomControls(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Background Layer ---
  Widget _buildCameraBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://via.placeholder.com/800x1200"), // Ganti dengan camera preview asli
          fit: BoxFit.cover,
          opacity: 0.8,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
      ),
    );
  }

  // --- Header & Info Card ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: controller.onBack,
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                style: IconButton.styleFrom(backgroundColor: Colors.black26),
              ),
              const Text(
                "Absen Upacara",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 48), // Spacer
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? const Color(0xFF101922).withOpacity(0.95) : Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: const Text("WAJIB", style: TextStyle(color: Color(0xFF137FEC), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Obx(() => Text(controller.eventName.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  ],
                ),
                const SizedBox(height: 8),
                _iconLabel(Icons.schedule, controller.eventTime.value),
                _iconLabel(Icons.location_on, controller.eventLocation.value),
              ],
            ),
          ),
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.1)),
            ),
            child: const Icon(Icons.qr_code_scanner, color: Color(0xFF137FEC), size: 32),
          )
        ],
      ),
    );
  }

  Widget _iconLabel(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  // --- Scanner Section ---
  Widget _buildScannerArea() {
    return Column(
      children: [
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            children: [
              // Scanner Frame (Corner Markers)
              _buildScannerFrame(),
              // Laser Animation
              const _ScannerLaser(),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               _PulseDot(),
               SizedBox(width: 8),
               Text("Mencari QR Code...", style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildScannerFrame() {
    const double cornerSize = 30;
    const double thickness = 4;
    const Color color = Color(0xFF137FEC);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24, width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          _corner(top: 0, left: 0, border: const Border(top: BorderSide(color: color, width: thickness), left: BorderSide(color: color, width: thickness))),
          _corner(top: 0, right: 0, border: const Border(top: BorderSide(color: color, width: thickness), right: BorderSide(color: color, width: thickness))),
          _corner(bottom: 0, left: 0, border: const Border(bottom: BorderSide(color: color, width: thickness), left: BorderSide(color: color, width: thickness))),
          _corner(bottom: 0, right: 0, border: const Border(bottom: BorderSide(color: color, width: thickness), right: BorderSide(color: color, width: thickness))),
        ],
      ),
    );
  }

  Widget _corner({double? top, double? bottom, double? left, double? right, required BoxBorder border}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(border: border, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // --- Bottom Controls ---
  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green.withOpacity(0.3))),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 14),
                SizedBox(width: 6),
                Text("LOKASI TERVERIFIKASI", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Arahkan kamera ke QR Code petugas. Pastikan Anda berada di dalam radius lokasi upacara.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 24),
          Obx(() => IconButton(
            onPressed: controller.toggleFlash,
            icon: Icon(controller.isFlashOn.value ? Icons.flashlight_on : Icons.flashlight_off, color: Colors.white, size: 28),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white10,
              padding: const EdgeInsets.all(20),
              side: const BorderSide(color: Colors.white24),
            ),
          )),
        ],
      ),
    );
  }
}

class _ScannerLaser extends StatefulWidget {
  const _ScannerLaser();
  @override
  State<_ScannerLaser> createState() => _ScannerLaserState();
}

class _ScannerLaserState extends State<_ScannerLaser> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _animation = Tween<double>(begin: 0, end: 280).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: _animation.value,
          left: 0, right: 0,
          child: Column(
            children: [
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF137FEC),
                  boxShadow: [BoxShadow(color: const Color(0xFF137FEC).withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [const Color(0xFF137FEC).withOpacity(0.2), Colors.transparent],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
    );
  }
}