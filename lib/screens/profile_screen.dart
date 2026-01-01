import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import 'wishlist_screen.dart';
import 'login_screen.dart';
import 'main_screen.dart'; // To access MainController
import 'profile_edit_screen.dart';
import 'profile_orders_screen.dart';
import 'profile_address_screen.dart';
import 'profile_payment_screen.dart';
import 'profile_settings_screen.dart';
import 'profile_support_screen.dart';

import 'dart:io';

class ProfileController extends GetxController {
  // Use persistent data or mock for now, but reactive
  final RxBool isLoggedIn = false.obs; // Auth State
  final RxString userName = "Naveed".obs;
  final RxString userEmail = "naveed@gmail.com".obs;
  final RxString userPhone = "+1 234 567 890".obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  
  void updateProfile(String name, String email, String phone, File? image) {
    userName.value = name;
    userEmail.value = email;
    userPhone.value = phone;
    if (image != null) {
      profileImage.value = image;
    }
    update(); // Notify listeners just in case
  }
  
  void login() {
    isLoggedIn.value = true;
    Get.snackbar("Success", "Logged in successfully", backgroundColor: AppColors.success, colorText: Colors.white);
  }

  void logout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () {
        Get.back(); // Close dialog
        isLoggedIn.value = false; // Set state to logged out
        // No need to navigate if ProfileScreen handles the view based on state
      }
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Put controller so it persists
    final ProfileController controller = Get.put(ProfileController());

    return Obx(() {
      if (!controller.isLoggedIn.value) {
        return const LoginScreen();
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(controller),
              const SizedBox(height: 20),
              _buildMenu(context, controller),
               const SizedBox(height: 40),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Obx(() {
            return Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondary, width: 2), // Gold border
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundImage: controller.profileImage.value != null 
                    ? FileImage(controller.profileImage.value!) 
                    : const AssetImage("assets/images/profile_pic.jpg") as ImageProvider,
                backgroundColor: Colors.white,
              ),
            );
          }),
          const SizedBox(width: 20),
          
          // Use Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                  controller.userName.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                const SizedBox(height: 4),
                Obx(() => Text(
                  controller.userEmail.value,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                )),
              ],
            ),
          ),
          


// ... (in _buildHeader)
          IconButton(
            onPressed: () {
               Get.to(() => const EditProfileScreen());
            }, 
            icon: const Icon(Icons.edit, color: AppColors.secondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context, ProfileController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: "My Orders",
            subtitle: "View order history",
            onTap: () {
               Get.to(() => const OrdersScreen());
            }
          ),
          _buildMenuItem(
            icon: Icons.favorite_border,
            title: "Wishlist",
            subtitle: "Your saved items",
            onTap: () {
               // Switch to Wishlist Tab (Index 2)
              if (Get.isRegistered<MainController>()) {
                  Get.find<MainController>().changeTab(2);
              }
            }
          ),
          _buildMenuItem(
            icon: Icons.location_on_outlined,
            title: "Shipping Address",
            subtitle: "Manage delivery locations",
            onTap: () {
              Get.to(() => const AddressScreen());
            }
          ),
          _buildMenuItem(
            icon: Icons.payment_outlined,
            title: "Payment Methods",
            subtitle: "Manage credit cards",
            onTap: () {
              Get.to(() => const PaymentMethodsScreen());
            }
          ),
          const SizedBox(height: 20),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: "Settings",
            subtitle: "Notifications, Privacy, Language",
            onTap: () {
              Get.to(() => const SettingsScreen());
            }
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: "Help & Support",
            subtitle: "FAQ & Customer Service",
            onTap: () {
              Get.to(() => const SupportScreen());
            }
          ),
          const SizedBox(height: 30),
          
          // Minimalist Logout Item (Left Aligned)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: controller.logout,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30), // Capsule shape
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min, // Shrink to fit content
                    children: [
                      Icon(Icons.logout, color: AppColors.primary, size: 20),
                      SizedBox(width: 10),
                      Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 15, 
                          fontWeight: FontWeight.bold, 
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : AppColors.primary,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDestructive ? Colors.red : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      ),
    );
  }
}
