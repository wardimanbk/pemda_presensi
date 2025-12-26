import 'package:get/get.dart';

import '../modules/attendance/bindings/attendance_binding.dart';
import '../modules/attendance/views/attendance_view.dart';
import '../modules/attendance_qr/bindings/attendance_qr_binding.dart';
import '../modules/attendance_qr/views/attendance_qr_view.dart';
import '../modules/attendance_tl/bindings/attendance_tl_binding.dart';
import '../modules/attendance_tl/views/attendance_tl_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/pengajuan_cuti/bindings/pengajuan_cuti_binding.dart';
import '../modules/pengajuan_cuti/views/pengajuan_cuti_view.dart';
import '../modules/profil/bindings/profil_binding.dart';
import '../modules/profil/views/profil_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.PROFIL;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => const SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCE,
      page: () => const AttendanceView(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCE_QR,
      page: () => const AttendanceQrView(),
      binding: AttendanceQrBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCE_TL,
      page: () => const AttendanceTlView(),
      binding: AttendanceTlBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.PENGAJUAN_CUTI,
      page: () => const PengajuanCutiView(),
      binding: PengajuanCutiBinding(),
    ),
    GetPage(
      name: _Paths.PROFIL,
      page: () => const ProfilView(),
      binding: ProfilBinding(),
    ),
  ];
}
