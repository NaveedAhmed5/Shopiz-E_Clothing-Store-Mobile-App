import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../controllers/payment_controller.dart';
import '../models/payment_method_model.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Find global controller
    final PaymentController controller = Get.find<PaymentController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Payment Methods", style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: Obx(() {
        if (controller.paymentMethods.isEmpty) {
          return const Center(child: Text("No payment methods. Add one!"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.paymentMethods.length,
          itemBuilder: (context, index) {
            final method = controller.paymentMethods[index];
            return _buildPaymentCard(method, controller);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCardDialog(context, controller),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.secondary),
      ),
    );
  }

  Widget _buildPaymentCard(PaymentMethod method, PaymentController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.credit_card, color: AppColors.primary, size: 30),
        title: Row(
          children: [
            Text(method.cardNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.tertiary)),
            if (method.isDefault) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                child: const Text("DEFAULT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
              )
            ]
          ],
        ),
        subtitle: Text("Expires: ${method.expiryDate} \u2022 ${method.cardHolderName}", style: const TextStyle(color: AppColors.textTertiary)),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'default') {
              controller.setDefault(method);
            } else if (value == 'delete') {
              controller.deletePaymentMethod(method);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            if (!method.isDefault)
              const PopupMenuItem<String>(
                value: 'default',
                child: Text('Set as Default'),
              ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Remove Card', style: TextStyle(color: AppColors.textTertiary)),
            ),
          ],
        ),
        onTap: () {
           controller.selectPaymentMethod(method);
        },
      ),
    );
  }

  void _showAddCardDialog(BuildContext context, PaymentController controller) {
    final numberController = TextEditingController();
    final nameController = TextEditingController();
    final expiryController = TextEditingController();

    Get.defaultDialog(
      title: "Add New Card",
      content: Column(
        children: [
          TextField(
            controller: numberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            decoration: const InputDecoration(
              labelText: "Card Number (16 digits)", 
              border: OutlineInputBorder(),
              counterText: "",
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Cardholder Name", border: OutlineInputBorder()),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: expiryController,
             keyboardType: TextInputType.datetime,
            inputFormatters: [
               LengthLimitingTextInputFormatter(5), // MM/YY
            ],
            decoration: const InputDecoration(labelText: "Expiry (MM/YY)", border: OutlineInputBorder(), hintText: "MM/YY"),
          ),
        ],
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      confirmTextColor: AppColors.tertiary,
      buttonColor: AppColors.primary,
      cancelTextColor: AppColors.tertiary,
      onConfirm: () {
        String num = numberController.text.trim();
        String name = nameController.text.trim();
        String expiry = expiryController.text.trim();
        
        if (num.isEmpty || name.isEmpty || expiry.isEmpty) {
          Get.snackbar("Error", "Please fill all fields", backgroundColor: AppColors.error, colorText: Colors.white);
          return;
        }
        
        if (num.length != 16) {
           Get.snackbar("Invalid Card", "Card number must be 16 digits", backgroundColor: AppColors.error, colorText: Colors.white);
           return;
        }

        // Basic Regex for MM/YY
        if (!RegExp(r"^(0[1-9]|1[0-2])\/\d{2}$").hasMatch(expiry)) {
           Get.snackbar("Invalid Expiry", "Use format MM/YY", backgroundColor: AppColors.error, colorText: Colors.white);
           return;
        }

        controller.addPaymentMethod(num, name, expiry);
        Get.back(); // Dismiss dialog
      }
    );
  }
}
