import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  static const Color primaryColor = Color(0xFF137FEC);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Get.isDarkMode;
    final Color surfaceColor = isDarkMode ? const Color(0xFF1C2834) : Colors.white;
    final Color bgColor = isDarkMode ? const Color(0xFF101922) : const Color(0xFFF6F7F8);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  _buildHeader(isDarkMode, surfaceColor),
                  const SizedBox(height: 48),
                  _buildLoginForm(isDarkMode, surfaceColor),
                  const SizedBox(height: 40),
                  _buildFooter(isDarkMode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode, Color surface) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            border: Border.all(color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05)),
          ),
          child: const Icon(Icons.account_balance, size: 48, color: primaryColor),
        ),
        const SizedBox(height: 24),
        Text(
          "Sistem Presensi Pegawai",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26, 
            fontWeight: FontWeight.bold, 
            color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "E-Absensi Mobile Attendance",
          style: TextStyle(fontSize: 16, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildLoginForm(bool isDarkMode, Color surface) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("NIP / Username", isDarkMode),
        _buildTextField(
          controller: controller.usernameController,
          hint: "Masukkan NIP atau Username",
          icon: Icons.badge_outlined,
          surface: surface,
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 20),
        _label("Password", isDarkMode),
        Obx(() => _buildTextField(
          controller: controller.passwordController,
          hint: "Masukkan password",
          icon: Icons.lock_outline,
          surface: surface,
          isDarkMode: isDarkMode,
          isPassword: true,
          obscureText: !controller.isPasswordVisible.value,
          onSuffixPressed: controller.togglePasswordVisibility,
        )),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Obx(() => Checkbox(
                  value: controller.isRememberMeChecked.value,
                  activeColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: controller.toggleRememberMe,
                )),
                Text("Ingat Saya", style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[700])),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Lupa Password?", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: controller.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text("MASUK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
        ),
        const SizedBox(height: 24),
        _buildDivider(isDarkMode),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: controller.biometricLogin,
            icon: const Icon(Icons.fingerprint, size: 28),
            label: const Text("Login Biometrik", style: TextStyle(fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(color: primaryColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  // --- Reusable Components ---
  Widget _label(String text, bool isDarkMode) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : Colors.amber)),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color surface,
    required bool isDarkMode,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixPressed,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey[500], size: 22),
        suffixIcon: isPassword ? IconButton(icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.grey[500]), onPressed: onSuffixPressed) : null,
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: primaryColor, width: 2)),
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) => Row(
    children: [
      Expanded(child: Divider(color: isDarkMode ? Colors.grey[800] : Colors.grey[300])),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text("METODE LAIN", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[500]))),
      Expanded(child: Divider(color: isDarkMode ? Colors.grey[800] : Colors.grey[300])),
    ],
  );

  Widget _buildFooter(bool isDarkMode) => Text("v1.0.2 © 2023 Dinas Kominfo", style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey[700] : Colors.grey[400]));
}
