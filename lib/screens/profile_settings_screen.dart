import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Local state for frontend-only toggle
    final RxBool isNotificationsEnabled = true.obs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("General", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
          const SizedBox(height: 10),
          Obx(() => _buildSwitchTile("Push Notifications", isNotificationsEnabled.value, (val) {
            isNotificationsEnabled.value = val;
          })),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.secondary,
      inactiveTrackColor: Colors.grey[300],
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
    );
  }
}
