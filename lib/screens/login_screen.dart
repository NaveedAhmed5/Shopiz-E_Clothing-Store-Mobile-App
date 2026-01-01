import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_screen.dart';
import '../constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textTertiary),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(25.0),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Image.asset('assets/images/Shopiz_Logo.png', height: 100, color: AppColors.secondary),
          ),
          const SizedBox(height: 20),
          const Text(
            "Welcome Back",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.secondary),
          ),
          const SizedBox(height: 10),
          const Text(
            "Log in to your account to continue shopping",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.secondary, fontSize: 16),
          ),
          const SizedBox(height: 40),

          TextField(
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: "Email",
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.secondary), // Gold border
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.transparent), // Clean look
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.secondary, width: 2), // Gold on focus
              ),
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
              filled: true,
              fillColor: Colors.white, // White box for readability
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            obscureText: true,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.secondary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.secondary, width: 2),
              ),
              prefixIcon: const Icon(Icons.lock_open, color: AppColors.primary),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary, // Gold button
              foregroundColor: AppColors.primary,   // Red text for contrast
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            child: const Text("LOGIN", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 15),

          TextButton(
            onPressed: () {
              Get.to(() => const SignupScreen());
            },
            child: const Text("Don't have an account? Sign Up", style: TextStyle(color: AppColors.secondary)), // Gold text
          ),
        ],
      ),
    );
  }
}
