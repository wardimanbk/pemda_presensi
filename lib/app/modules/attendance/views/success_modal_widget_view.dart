import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_controller.dart';

class SuccessModalWidgetView extends GetView<AttendanceController> {
  const SuccessModalWidgetView({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final Color surfaceColor = isDark ? const Color(0xFF1A2632) : Colors.white;
    const Color successColor = Color(0xFF22C55E);
    const Color primaryColor = Color(0xFF137FEC);

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Material( // Material diperlukan agar styling text/button bekerja di dalam dialog
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Header Section ---
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: successColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: successColor.withOpacity(0.1), width: 8),
                      ),
                      child: const Icon(Icons.check_circle, size: 48, color: successColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "ABSEN BERHASIL!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0D141B),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Anda berhasil melakukan absensi masuk hari ini.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),

              // --- Details Section ---
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Time and Date
                    Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: controller.currentTime.value,
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF0D141B),
                                ),
                              ),
                              TextSpan(
                                text: " WIB",
                                style: TextStyle(fontSize: 16, color: Colors.grey[400], fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          controller.currentDate.value,
                          style: TextStyle(color: Colors.grey[500], fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Status & Location Rows
                    _buildInfoRow(
                      context,
                      isDark,
                      icon: Icons.schedule,
                      iconColor: primaryColor,
                      label: "Status",
                      trailing: _buildBadge("Tepat Waktu"),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      isDark,
                      icon: Icons.location_on,
                      iconColor: Colors.orange,
                      label: "Lokasi",
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(controller.officeName.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(controller.officeDetail.value, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Subtle Offline Note
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_done, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "DATA TERSIMPAN LOKAL",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[400], letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- Action Button ---
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Get.back(), // Tutup Modal
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      shadowColor: primaryColor.withOpacity(0.3),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("OK, Saya Mengerti", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, bool isDark, {required IconData icon, required Color iconColor, required String label, required Widget trailing}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFFF6F7F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: const Text(
        "Tepat Waktu",
        style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
