import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profil_controller.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final Color primaryColor = const Color(0xFF137FEC);
    final Color surfaceColor = isDark ? const Color(0xFF1E2936) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : const Color(0xFFF6F7F8),
      appBar: _buildAppBar(isDark, surfaceColor),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(isDark, surfaceColor, primaryColor),
                  _buildEmploymentSection(isDark, surfaceColor),
                  _buildSettingsSection(isDark, surfaceColor, primaryColor),
                  _buildSupportSection(isDark, surfaceColor, primaryColor),
                  _buildVersionInfo(),
                ],
              ),
            ),
          ),
          _buildBottomNav(isDark, surfaceColor, primaryColor),
        ],
      ),
    );
  }

  // --- AppBar ---
  PreferredSizeWidget _buildAppBar(bool isDark, Color surface) {
    return AppBar(
      backgroundColor: surface,
      elevation: 0.5,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Text("Profil Saya", 
        style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      centerTitle: true,
    );
  }

  // --- Profile Header ---
  Widget _buildHeader(bool isDark, Color surface, Color primary) {
    return Container(
      width: double.infinity,
      color: surface,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primary.withOpacity(0.1), width: 4),
                  image: const DecorationImage(
                    image: NetworkImage("https://via.placeholder.com/150"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: primary, shape: BoxShape.circle, border: Border.all(color: surface, width: 2)),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
              Positioned(
                top: 5, right: 5,
                child: Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: surface, width: 2)),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Text(controller.name.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Obx(() => Text(controller.position.value, style: TextStyle(color: primary, fontSize: 13, fontWeight: FontWeight.w600))),
          ),
          const SizedBox(height: 8),
          Obx(() => Text("NIP: ${controller.nip.value}", style: const TextStyle(color: Colors.grey, fontSize: 13))),
        ],
      ),
    );
  }

  // --- Employment Info ---
  Widget _buildEmploymentSection(bool isDark, Color surface) {
    return _sectionWrapper(
      title: "Informasi Kepegawaian",
      child: Container(
        decoration: _cardDecoration(isDark, surface),
        child: Column(
          children: [
            _infoTile(Icons.apartment, "SKPD", controller.skpd.value, isDark),
            _infoTile(Icons.location_on, "Lokasi", controller.location.value, isDark),
            _infoTile(Icons.call, "No. HP", controller.phone.value, isDark, isLocked: true),
          ],
        ),
      ),
    );
  }

  // --- Settings ---
  Widget _buildSettingsSection(bool isDark, Color surface, Color primary) {
    return _sectionWrapper(
      title: "Pengaturan",
      child: Container(
        decoration: _cardDecoration(isDark, surface),
        child: Column(
          children: [
            _settingTile(
              icon: Icons.fingerprint, 
              title: "Pengaturan Biometrik", 
              subtitle: "Login dengan FaceID/TouchID", 
              primary: primary,
              trailing: Obx(() => Switch.adaptive(
                value: controller.isBiometricActive.value, 
                onChanged: controller.toggleBiometric,
                activeColor: primary,
              )),
            ),
            _settingTile(icon: Icons.notifications, title: "Pengaturan Notifikasi", primary: primary),
            _settingTile(icon: Icons.lock_reset, title: "Ganti Password", primary: primary),
          ],
        ),
      ),
    );
  }

  // --- Support ---
  Widget _buildSupportSection(bool isDark, Color surface, Color primary) {
    return _sectionWrapper(
      title: "Bantuan",
      child: Column(
        children: [
          Container(
            decoration: _cardDecoration(isDark, surface),
            child: _settingTile(icon: Icons.help, title: "Bantuan & FAQ", primary: primary),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: controller.onLogout,
              icon: const Icon(Icons.logout, size: 20),
              label: const Text("Keluar Aplikasi", style: TextStyle(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red.withOpacity(0.2)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- Bottom Navigation Mockup ---
  Widget _buildBottomNav(bool isDark, Color surface, Color primary) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, "Beranda", false),
          _navItem(Icons.calendar_month, "Riwayat", false),
          _navItem(Icons.qr_code_scanner, "Scan", false, isFab: true, primary: primary),
          _navItem(Icons.notifications, "Inbox", false),
          _navItem(Icons.person, "Profil", true, primary: primary),
        ],
      ),
    );
  }

  // --- Reusable UI Parts ---

  Widget _sectionWrapper({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration(bool isDark, Color surface) {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, bool isDark, {bool isLocked = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                if (isLocked) ...[const SizedBox(width: 4), const Icon(Icons.lock, size: 14, color: Colors.grey)]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingTile({required IconData icon, required String title, String? subtitle, required Color primary, Widget? trailing}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive, {bool isFab = false, Color? primary}) {
    if (isFab) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.translate(
            offset: const Offset(0, -15),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: primary, shape: BoxShape.circle, boxShadow: [BoxShadow(color: primary!.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
          ),
          Text(label, style: TextStyle(fontSize: 10, color: primary, fontWeight: FontWeight.bold)),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? primary : Colors.grey, size: 24),
        Text(label, style: TextStyle(fontSize: 10, color: isActive ? primary : Colors.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildVersionInfo() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Text("Versi Aplikasi 2.4.0 (Build 102)", style: TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }
}
