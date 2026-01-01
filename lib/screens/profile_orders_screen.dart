import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../models/order_model.dart';
import '../controllers/order_controller.dart'; // Import standalone controller

// --- ORDERS SCREEN ---
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    final OrderController controller = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Orders", style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: Obx(() {
        if (controller.orders.isEmpty) {
           return Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Icon(Icons.history, size: 80, color: Colors.grey[300]),
                 const SizedBox(height: 16),
                 const Text(
                   "No order history",
                   style: TextStyle(fontSize: 18, color: Colors.grey),
                 ),
               ],
             ),
           );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            return _buildOrderCard(controller.orders[index], controller);
          },
        );
      }),
    );
  }

  Widget _buildOrderCard(Order order, OrderController controller) {
    Color statusColor;
    String statusText;

    switch (order.status) {
      case OrderStatus.processing:
        statusColor = AppColors.tertiary; // Amber/Gold
        statusText = "Processing";
        break;
      case OrderStatus.delivered:
        statusColor = AppColors.tertiary; // Material Green
        statusText = "Delivered";
        break;
      case OrderStatus.cancelled:
        statusColor = AppColors.tertiary;
        statusText = "Cancelled";
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order #${order.id}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.tertiary)),
                    const SizedBox(height: 4),
                    Text(
                      "${order.date.day}/${order.date.month}/${order.date.year}", 
                      style: TextStyle(color: AppColors.textTertiary, fontSize: 12)
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: statusColor.withOpacity(0.2)),
                  ),
                  child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            
            // Order Items
            Column(
              children: order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[100]!),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))
                        ],
                        image: DecorationImage(
                          image: item.product.imageUrls.isNotEmpty && !item.product.imageUrls[0].startsWith('http')
                                  ? AssetImage(item.product.imageUrls[0]) as ImageProvider
                                  : NetworkImage(item.product.imageUrls.isNotEmpty ? item.product.imageUrls[0] : ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text("Size: ${item.selectedSize}", style: TextStyle(color: Colors.grey[800], fontSize: 10, fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(width: 8),
                              Text("Qty: ${item.quantity.value}", style: TextStyle(color: AppColors.textTertiary, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text("\$${item.totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              )).toList(),
            ),
            
            const Divider(height: 20),
            
            // Footer: Total & Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                if (order.status == OrderStatus.processing)
                  OutlinedButton(
                    onPressed: () => controller.cancelOrder(order),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textTertiary,
                      side: const BorderSide(color: AppColors.textTertiary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text("X Cancel Order", style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
