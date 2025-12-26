import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Create Account",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(25.0),
        children: [
          // UPDATED: Added Logo at the top
          Center(
            child: Image.asset('assets/images/Shopiz_Logo.png', height: 80),
          ),
          const SizedBox(height: 20),
          const Text(
            "Join Shopiz",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0056D2),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Enter your details to get started",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
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
              backgroundColor: const Color(0xFF0056D2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
              Text(
                "Already have an account? ",
                style: TextStyle(color: Colors.grey[700]),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: const Text(
                  "Log In",
                  style: TextStyle(
                    color: Color(0xFF0056D2),
                    fontWeight: FontWeight.bold,
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
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Color(0xFF0056D2), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
