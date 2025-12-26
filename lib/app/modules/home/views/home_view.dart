import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  static const Color primaryBlue = Color(0xFF137FEC);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final Color surfaceColor = isDark ? const Color(0xFF1B2631) : Colors.white;
    final Color bgColor = isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeader(isDark, surfaceColor),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildStatusCard(),
                    const SizedBox(height: 24),
                    _buildMenuGrid(isDark, surfaceColor),
                    const SizedBox(height: 24),
                    _buildTPPPerformance(isDark, surfaceColor),
                    const SizedBox(height: 24),
                    _buildRecentActivity(isDark, surfaceColor),
                    const SizedBox(height: 100), // Spacer untuk Bottom Nav
                  ]),
                ),
              ),
            ],
          ),
          _buildBottomNav(isDark, surfaceColor),
        ],
      ),
    );
  }

  // --- Header Section ---
  Widget _buildHeader(bool isDark, Color surface) {
    return SliverToBoxAdapter(
      child: Container(
        color: surface,
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage("https://via.placeholder.com/150"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        "Halo, ${controller.userName.value}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                      )),
                      Obx(() => Text(
                        "NIP: ${controller.nip.value}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      )),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.onNotificationPressed,
                  icon: const Icon(Icons.notifications_outlined),
                  color: isDark ? Colors.white70 : Colors.black54,
                )
              ],
            ),
            const SizedBox(height: 16),
            _buildGeofenceBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeofenceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, size: 16, color: Colors.green),
          SizedBox(width: 4),
          Text(
            "Kantor Gubernur (Dalam Jangkauan)",
            style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // --- Status Card (Gradient) ---
  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryBlue, Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: primaryBlue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(controller.statusDate.value, style: const TextStyle(color: Colors.white70, fontSize: 14))),
                  const SizedBox(height: 4),
                  Obx(() => Text("${controller.checkInTime.value} WIB", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                child: const Text("HADIR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildTimeBox("Masuk", controller.checkInTime.value, Icons.login),
              const SizedBox(width: 12),
              _buildTimeBox("Pulang", controller.checkOutTime.value, Icons.logout),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTimeBox(String label, String time, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: Colors.white70),
                const SizedBox(width: 4),
                Text(label.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Text(time, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // --- Menu Grid ---
  Widget _buildMenuGrid(bool isDark, Color surface) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Menu Presensi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _menuButton("Absen Masuk", "Catat kehadiran", Icons.login, Colors.blue, surface, isDark),
            _menuButton("Absen Pulang", "Selesai bekerja", Icons.logout, Colors.orange, surface, isDark, opacity: 0.6),
            _menuButton("Upacara/Apel", "Kegiatan resmi", Icons.flag, Colors.red, surface, isDark),
            _menuButton("Tugas Luar", "Dinas luar kantor", Icons.business_center, Colors.purple, surface, isDark),
          ],
        ),
      ],
    );
  }

  Widget _menuButton(String title, String sub, IconData icon, Color color, Color surface, bool isDark, {double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
            Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  // --- TPP & Activity ---
  Widget _buildTPPPerformance(bool isDark, Color surface) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Performa TPP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Periode Oktober 2023", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Obx(() => Text("${(controller.tppPerformance.value * 100).toInt()}%", style: const TextStyle(color: primaryBlue, fontSize: 24, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Obx(() => LinearProgressIndicator(
              value: controller.tppPerformance.value,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(primaryBlue),
            )),
          )
        ],
      ),
    );
  }

  Widget _buildRecentActivity(bool isDark, Color surface) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Aktivitas Terkini", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextButton(onPressed: () {}, child: const Text("Lihat Semua", style: TextStyle(color: primaryBlue))),
          ],
        ),
        _activityItem("Absen Masuk (WFO)", "Terverifikasi via Face ID", "07:15", Icons.face, Colors.blue, surface, isDark),
      ],
    );
  }

  Widget _activityItem(String title, String sub, String time, IconData icon, Color color, Color surface, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(sub, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- Navigation ---
  Widget _buildBottomNav(bool isDark, Color surface) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: surface,
          border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, "Beranda", true),
            _navItem(Icons.history, "Riwayat", false),
            _buildFloatingQR(),
            _navItem(Icons.person, "Profil", false),
            _navItem(Icons.settings, "Akun", false),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: active ? primaryBlue : Colors.grey, size: 24),
        Text(label, style: TextStyle(fontSize: 10, color: active ? primaryBlue : Colors.grey)),
      ],
    );
  }

  Widget _buildFloatingQR() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: GestureDetector(
        onTap: controller.onScanQR,
        child: Container(
          height: 60, width: 60,
          decoration: BoxDecoration(
            color: primaryBlue,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: primaryBlue.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))],
            border: Border.all(color: Get.isDarkMode ? const Color(0xFF1B2631) : Colors.white, width: 4),
          ),
          child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
