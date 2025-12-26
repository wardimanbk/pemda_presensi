import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splashscreen_controller.dart';

class SplashscreenView extends GetView<SplashscreenController> {
  const SplashscreenView({super.key});
  @override
  Widget build(BuildContext context) {
    // Definisi Warna dari Tailwind Config Anda
    const Color primaryColor = Color(0xFF137FEC);
    const Color bgLight = Color(0xFFF6F7F8);
    
    // Mengecek apakah perangkat dalam mode gelap atau terang
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF101922) : bgLight,
      body: Stack(
        children: [
          // --- Decorative Background Elements ---
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(isDarkMode ? 0.1 : 0.05),
              ),
            ),
          ),
          
          // --- Main Content ---
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(flex: 2), // Top Spacer (15vh)

                // Center Content: Logo and Titles
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // Logo Container
                      Container(
                        width: 128,
                        height: 128,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF1A2632) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: isDarkMode ? Colors.white10 : Colors.black12,
                          ),
                        ),
                        child: Image.network(
                          "https://via.placeholder.com/150", // Ganti dengan URL Logo Pemkab
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Titles
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: isDarkMode ? Colors.white : const Color(0xFF0D141B),
                            fontFamily: 'Public Sans',
                          ),
                          children: const [
                            TextSpan(text: "Presensi "),
                            TextSpan(
                              text: "Mobile",
                              style: TextStyle(color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Pemerintah Kabupaten XYZ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                // Bottom Section: Loading & Meta
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0, left: 32, right: 32),
                  child: Column(
                    children: [
                      // Loading Text
                      Text(
                        "Memuat data...",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Progress Bar
                      Container(
                        width: 240,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white10 : Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.3, // Menunjukkan 30% sesuai HTML
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Version & Copyright
                      Text(
                        "Version 1.0.0",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "© 2024 Diskominfo Kab. XYZ",
                        style: TextStyle(
                          fontSize: 10,
                          color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
