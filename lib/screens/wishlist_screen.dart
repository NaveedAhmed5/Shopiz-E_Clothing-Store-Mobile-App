import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../constants.dart';
import 'item_view_screen.dart'; // To navigate to item details
import 'main_screen.dart'; // For MainController


// --- CONTROLLER ---
class WishlistController extends GetxController {
  // Global list of wishlisted products
  var wishlist = <Product>[].obs;

  void toggleWishlist(Product product) {
    if (isWishlisted(product)) {
      wishlist.remove(product);
      Get.snackbar(
        "Removed from Wishlist", 
        "${product.name} removed.", 
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white
      );
    } else {
      wishlist.add(product);
      Get.snackbar(
        "Added to Wishlist", 
        "${product.name} saved!", 
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.secondary,
        colorText: AppColors.primary
      );
    }
  }

  bool isWishlisted(Product product) {
    return wishlist.contains(product);
  }
}

// --- SCREEN ---
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is found
    final WishlistController controller = Get.put(WishlistController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Wishlist", style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Hidden since it's a tab
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: Obx(() {
        if (controller.wishlist.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text(
                  "Your wishlist is empty",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    try {
                      // Navigate to Shop Tab (Index 1)
                      if (Get.isRegistered<MainController>()) {
                         Get.find<MainController>().changeTab(1);
                      } else {
                        // Fallback: This shouldn't happen if MainScreen is the parent
                        print("MainController not found");
                      }
                    } catch (e) {
                      print("Error navigating: $e");
                    }
                  },
                  child: const Text("Go Shopping", style: TextStyle(color: AppColors.primary, fontSize: 16)),
                )
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.wishlist.length,
          itemBuilder: (context, index) {
            final product = controller.wishlist[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: product.imageUrls.isNotEmpty && !product.imageUrls[0].startsWith('http')
                        ? AssetImage(product.imageUrls[0]) as ImageProvider
                        : NetworkImage(product.imageUrls.isNotEmpty ? product.imageUrls[0] : ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                ),
                subtitle: Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () => controller.toggleWishlist(product),
                ),
                onTap: () {
                  Get.to(() => ItemViewScreen(product: product));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
