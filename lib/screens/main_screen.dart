import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'shopping_screen.dart'; 
import '../constants.dart';

// --- MAIN CONTROLLER ---
class MainController extends GetxController {
  var currentIndex = 0.obs; // Tracks which tab is active

  void changeTab(int index) {
    currentIndex.value = index;
    // Reset Home Banner if switching to Home Tab
    if (index == 0) {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().resetBanner();
      }
    }
  }
}

// --- MAIN SCREEN ---
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    // Define your pages here
    final List<Widget> pages = [
      const HomeScreen(),
      const ShoppingScreen(), // 1: Shop
      const Scaffold(backgroundColor: AppColors.background, body: Center(child: Text("Wishlist Screen", style: TextStyle(color: AppColors.textPrimary)))), // 2: Wishlist
      const Scaffold(backgroundColor: AppColors.background, body: Center(child: Text("Cart Screen", style: TextStyle(color: AppColors.textPrimary)))),     // 3: Cart
      const Scaffold(backgroundColor: AppColors.background, body: Center(child: Text("Profile Screen", style: TextStyle(color: AppColors.textPrimary)))),  // 4: Profile
    ];

    return WillPopScope(
      onWillPop: () async {
        if (controller.currentIndex.value != 0) {
          controller.changeTab(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Obx(() => pages[controller.currentIndex.value]),
        
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          child: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            backgroundColor: AppColors.surface.withOpacity(0.95),
            selectedItemColor: AppColors.secondary,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          )),
        ),
      ),
    );
  }
}