import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../constants.dart';

import '../models/cart_item_model.dart';
import '../controllers/order_controller.dart';
import '../controllers/address_controller.dart';
import '../screens/profile_address_screen.dart';
import '../controllers/payment_controller.dart';
import '../screens/profile_payment_screen.dart';

// --- CONTROLLER ---
class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  double get totalAmount => cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity.value);

  void addToCart(Product product, String size, int colorIndex, int quantity) {
    // Check if item already exists with same variants
    final existingItemIndex = cartItems.indexWhere((item) => 
      item.product.id == product.id && 
      item.selectedSize == size && 
      item.selectedColorIndex == colorIndex
    );

    if (existingItemIndex != -1) {
      cartItems[existingItemIndex].quantity.value += quantity;
      Get.snackbar(
        "Cart Updated", 
        "Increased quantity of ${product.name}",
        backgroundColor: AppColors.secondary,
        colorText: AppColors.primary,
        duration: const Duration(seconds: 1),
      );
    } else {
      cartItems.add(CartItem(
        product: product,
        selectedSize: size,
        selectedColorIndex: colorIndex,
        quantity: quantity,
      ));
      Get.snackbar(
        "Added to Cart", 
        "${product.name} added!",
        backgroundColor: AppColors.secondary,
        colorText: AppColors.primary,
        duration: const Duration(seconds: 1),
      );
    }
  }

  void removeFromCart(CartItem item) {
    cartItems.remove(item);
    Get.snackbar(
      "Removed from Cart", 
      "${item.product.name} removed.", 
      duration: const Duration(seconds: 1),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white
    );
  }

  void incrementQuantity(CartItem item) {
    item.quantity.value++;
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity.value > 1) {
      item.quantity.value--;
    } else {
      removeFromCart(item);
    }
  }
  
  void checkout() {
    if (cartItems.isEmpty) {
       Get.snackbar("Cart Empty", "Add items to cart first!", backgroundColor: AppColors.error, colorText: Colors.white);
       return;
    }
    
    // Ensure Controllers are available (Find global instance)
    final AddressController addressController = Get.find<AddressController>();
    final PaymentController paymentController = Get.find<PaymentController>();
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Checkout", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 20),
            
            // Shipping Address Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Shipping Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                TextButton(
                  onPressed: () => Get.to(() => const AddressScreen(), preventDuplicates: false),
                  child: const Text("Change", style: TextStyle(color: AppColors.primary)),
                )
              ],
            ),
            const SizedBox(height: 10),
            Obx(() {
               final selected = addressController.selectedAddress.value;
               if (selected == null) {
                 return Container(
                   padding: const EdgeInsets.all(12),
                   child: const Row(children: [Icon(Icons.error_outline, color: AppColors.primary), SizedBox(width: 8), Text("No address selected. Please add one.", style: TextStyle(color: AppColors.textPrimary))])
                 );
               }
               return Container(
                 width: double.infinity,
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      Row(children: [
                        const Icon(Icons.location_on, size: 16, color: AppColors.primary), 
                        const SizedBox(width: 8), 
                        Text(selected.label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))
                      ]),
                      const SizedBox(height: 4),
                      Text(selected.fullAddress, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                   ],
                 ),
               );
            }),

            const SizedBox(height: 20),

            // Payment Method Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                TextButton(
                  onPressed: () => Get.to(() => const PaymentMethodsScreen(), preventDuplicates: false),
                  child: const Text("Change", style: TextStyle(color: AppColors.primary)),
                )
              ],
            ),
            const SizedBox(height: 10),
            Obx(() {
               final selected = paymentController.selectedPaymentMethod.value;
               if (selected == null) {
                 return Container(
                   padding: const EdgeInsets.all(12),
                   child: const Row(children: [Icon(Icons.error_outline, color: AppColors.primary), SizedBox(width: 8), Text("No card selected. Please add one.", style: TextStyle(color: AppColors.textPrimary))])
                 );
               }
               return Container(
                 width: double.infinity,
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      Row(children: [
                        const Icon(Icons.credit_card, size: 16, color: AppColors.primary), 
                        const SizedBox(width: 8), 
                        Text("Card ending in ${selected.cardNumber.substring(selected.cardNumber.length - 4)}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))
                      ]),
                      const SizedBox(height: 4),
                      Text("Expires: ${selected.expiryDate}", style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                   ],
                 ),
               );
            }),
            
            const SizedBox(height: 30),
            
            // Total & Confirm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Amount:", style: TextStyle(fontSize: 16, color: AppColors.primary)),
                Text("\$${totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                   if (addressController.selectedAddress.value == null) {
                      Get.snackbar("Shipping Address Missing", "Please select a shipping address.", backgroundColor: AppColors.error, colorText: Colors.white);
                      return;
                   }

                   if (paymentController.selectedPaymentMethod.value == null) {
                      Get.snackbar("Payment Method Missing", "Please select a payment method.", backgroundColor: AppColors.error, colorText: Colors.white);
                      return;
                   }
                   
                   // Find OrderController
                   final OrderController orderController = Get.find<OrderController>();
    
                   // Add order with details (could extend order model to store address/payment too)
                   orderController.addOrder(cartItems, totalAmount);
    
                   cartItems.clear();
                   Get.back(); // Close BottomSheet
                   Get.snackbar("Success", "Order Placed Successfully!", backgroundColor: AppColors.success, colorText: Colors.white);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Confirm Order", style: TextStyle(color: AppColors.secondary, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

// --- SCREEN ---
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Cart", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
        automaticallyImplyLeading: false, 
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text(
                  "Your cart is empty",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Image
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: item.product.imageUrls.isNotEmpty && !item.product.imageUrls[0].startsWith('http')
                                  ? AssetImage(item.product.imageUrls[0]) as ImageProvider
                                  : NetworkImage(item.product.imageUrls.isNotEmpty ? item.product.imageUrls[0] : ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.product.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                                      onPressed: () => controller.removeFromCart(item),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      splashRadius: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Size: ${item.selectedSize} | Color: ", // Improve Color display if needed
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                                if (item.product.colors.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 16, height: 16,
                                    decoration: BoxDecoration(
                                      color: item.product.colors[item.selectedColorIndex],
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey[300]!)
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "\$${item.product.price.toStringAsFixed(2)}",
                                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    
                                    // Quantity Controls
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove, size: 16, color: AppColors.textPrimary),
                                            onPressed: () => controller.decrementQuantity(item),
                                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            padding: EdgeInsets.zero,
                                          ),
                                          Obx(() => Text(
                                            "${item.quantity.value}",
                                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                                          )),
                                          IconButton(
                                            icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                                            onPressed: () => controller.incrementQuantity(item),
                                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Total & Checkout
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      Obx(() => Text(
                        "\$${controller.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.checkout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Checkout", style: TextStyle(color: AppColors.secondary, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
