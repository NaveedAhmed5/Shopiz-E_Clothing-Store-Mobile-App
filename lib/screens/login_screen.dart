import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_screen.dart';
import '../constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(25.0),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Image.asset('assets/images/Shopiz_Logo.png', height: 100),
          ),
          const SizedBox(height: 20),
          const Text(
            "Welcome Back",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          const Text(
            "Log in to your account to continue shopping",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 40),

          TextField(
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            obscureText: true,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              prefixIcon: const Icon(Icons.lock_open, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("LOGIN", style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 15),

          TextButton(
            onPressed: () {
              Get.to(() => const SignupScreen());
            },
            child: const Text("Don't have an account? Sign Up", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
