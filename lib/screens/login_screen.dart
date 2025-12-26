import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(25.0),
        children: [
          const SizedBox(height: 20),
          // UPDATED: Displaying Logo instead of Lock Icon
          Center(
            child: Image.asset('assets/images/Shopiz_Logo.png', height: 100),
          ),
          const SizedBox(height: 20),
          const Text(
            "Welcome Back",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "Log in to your account to continue shopping",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 40),

          TextField(
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.lock_open),
            ),
          ),
          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0056D2),
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
            child: const Text("Don't have an account? Sign Up"),
          ),
        ],
      ),
    );
  }
}
