import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../controllers/address_controller.dart';
import '../models/address_model.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is present (Find global instance)
    final AddressController controller = Get.find<AddressController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Shipping Addresses", style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: Obx(() {
        if (controller.addresses.isEmpty) {
          return const Center(child: Text("No addresses found. Add one!"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.addresses.length,
          itemBuilder: (context, index) {
            final address = controller.addresses[index];
            return _buildAddressCard(address, controller);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressDialog(context, controller),
         backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.secondary),
      ),
    );
  }

  Widget _buildAddressCard(Address address, AddressController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          address.isDefault ? Icons.location_on : Icons.location_on_outlined, 
          color: AppColors.primary
        ),
        title: Row(
          children: [
            Text(address.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.tertiary)),
            if (address.isDefault) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                child: const Text("DEFAULT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
              )
            ]
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(address.fullAddress, style: const TextStyle(height: 1.4, color: AppColors.textTertiary)),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'default') {
              controller.setDefault(address);
            } else if (value == 'delete') {
              controller.deleteAddress(address);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            if (!address.isDefault)
              const PopupMenuItem<String>(
                value: 'default',
                child: Text('Set as Default'),
              ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete Address', style: TextStyle(color: AppColors.textTertiary)),
            ),
          ],
        ),
        onTap: () {
           // Can be used to select if coming from checkout, logic handled in controller/checkout flow
           controller.selectAddress(address);
        },
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context, AddressController controller) {
    final labelController = TextEditingController();
    final addressController = TextEditingController();

    Get.defaultDialog(
      title: "Add New Address",
      content: Column(
        children: [
          TextField(
            controller: labelController,
            decoration: const InputDecoration(
              labelText: "Label (e.g. Home, Work)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: "Full Address",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      confirmTextColor: AppColors.tertiary,
      buttonColor: AppColors.primary,
      cancelTextColor: AppColors.tertiary,
      onConfirm: () {
        if (labelController.text.isNotEmpty && addressController.text.isNotEmpty) {
          controller.addAddress(labelController.text, addressController.text);
          Get.back();
        } else {
          Get.snackbar("Error", "Please fill all fields", backgroundColor: AppColors.error, colorText: Colors.white);
        }
      }
    );
  }
}
