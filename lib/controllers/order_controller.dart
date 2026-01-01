import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

import '../constants.dart';

class OrderController extends GetxController {
  // Use a static instance or find it easily.
  // For now, simpler to just rely on Get.find() if put() earlier.
  
  var orders = <Order>[].obs;

  void addOrder(List<CartItem> cartItems, double totalAmount) {
    // Create deep copy of cart items to persist in order even if cart clears
    final List<CartItem> orderItems = List<CartItem>.from(cartItems); 
    
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString().substring(8), 
      date: DateTime.now(),
      items: orderItems,
      totalAmount: totalAmount,
      status: OrderStatus.processing,
    );
    
    orders.insert(0, newOrder); // Add to top of list
  }

  void cancelOrder(Order order) {
    Get.defaultDialog(
      title: "Cancel Order",
      middleText: "Are you sure you want to cancel this order?",
      textConfirm: "Yes, Cancel",
      textCancel: "No",
      confirmTextColor: AppColors.tertiary,
      buttonColor: AppColors.primary,
      cancelTextColor: AppColors.tertiary,
      onConfirm: () {
        order.status = OrderStatus.cancelled;
        orders.refresh(); // Trigger UI update
        Get.back(); // Close dialog
        Get.snackbar("Order Cancelled", "Your order has been cancelled.", backgroundColor: AppColors.textPrimary, colorText: AppColors.tertiary);
      }
    );
  }
}
