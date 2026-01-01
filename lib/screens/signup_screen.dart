import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Red Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary), // Gold Icon
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Create Account",
          style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold), // Gold Title
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(25.0),
        children: [
          Center(
            child: Image.asset('assets/images/Shopiz_Logo.png', height: 80, color: AppColors.secondary), // Gold Logo
          ),
          const SizedBox(height: 20),
          const Text(
            "Join Shopiz",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary, // Gold Text
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Enter your details to get started",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.secondary, fontSize: 16), // Gold Text
          ),
          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: _buildTextField("First Name", Icons.person_outline),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildTextField("Last Name", Icons.person_outline),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField("Email Address", Icons.email_outlined),
          const SizedBox(height: 20),
          _buildTextField("Password", Icons.lock_outline, isPassword: true),
          const SizedBox(height: 20),
          _buildTextField("Address (Optional)", Icons.location_on_outlined),
          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              // Logic for Signup will go here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary, // Gold Button
              foregroundColor: AppColors.primary,   // Red Text
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            child: const Text(
              "SIGN UP",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(color: AppColors.secondary), // Gold Text
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: const Text(
                  "Log In",
                  style: TextStyle(
                    color: Colors.white, // White for contrast link
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.primary), // Red Icon
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondary), // Gold Border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.secondary, width: 2), // Gold Focus
        ),
        filled: true,
        fillColor: Colors.white, // White Box
      ),
    );
  }
}
