import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  // Reaktif variabel untuk UI
  final isPasswordVisible = false.obs;
  final isRememberMeChecked = false.obs;
  
  // Controller untuk mengambil data input
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleRememberMe(bool? value) => isRememberMeChecked.value = value ?? false;

  void login() {
    // Logika login Anda di sini
    print("Login sebagai: ${usernameController.text}");
  }

  void biometricLogin() {
    print("Memicu autentikasi biometrik...");
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
