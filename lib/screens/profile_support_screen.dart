import 'package:flutter/material.dart';
import '../constants.dart';

import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Help & Support", style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Frequently Asked Questions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          _buildExpansionTile("How do I return an item?", "You can return items within 30 days of purchase. Go to 'My Orders' and select 'Return'."),
          _buildExpansionTile("Where is my order?", "Check the tracking link in your confirmation email or visit 'My Orders'."),
          _buildExpansionTile("Do you ship internationally?", "Yes, we ship to over 50 countries worldwide."),
           const SizedBox(height: 30),
           const Text("Contact Us", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
           const SizedBox(height: 16),
           ListTile(
             leading: const Icon(Icons.email, color: AppColors.primary),
             title: const Text("Email Support", style: TextStyle(color: AppColors.textPrimary)),
             subtitle: const Text("support@shopiz.com", style: TextStyle(color: AppColors.textPrimary)),
             onTap: () => _launchEmail(),
           ),
           ListTile(
             leading: const Icon(Icons.phone, color: AppColors.primary),
             title: const Text("Call Us", style: TextStyle(color: AppColors.textPrimary)),
             subtitle: const Text("+1 (800) 123-4567", style: TextStyle(color: AppColors.textPrimary)),
             onTap: () => _launchPhone(),
           ),
        ],
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@shopiz.com',
      query: 'subject=Support Inquiry&body=Hi Shopiz Support,', 
    );
    try {
      if (!await launchUrl(emailLaunchUri)) {
        throw Exception('Could not launch email');
      }
    } catch (e) {
      debugPrint("Error launching email: $e");
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: '+18001234567',
    );
    try {
      if (!await launchUrl(phoneLaunchUri)) {
        throw Exception('Could not launch phone');
      }
    } catch (e) {
      debugPrint("Error launching phone: $e");
    }
  }

  Widget _buildExpansionTile(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey[200]!)),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(content, style: const TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }
}
