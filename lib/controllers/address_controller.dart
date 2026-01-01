import 'package:get/get.dart';
import '../models/address_model.dart';
import '../constants.dart';
import 'package:flutter/material.dart';

class AddressController extends GetxController {
  var addresses = <Address>[
    Address(
      id: "1",
      label: "Home",
      fullAddress: "123 Main Street, Apt 4B\nNew York, NY 10001",
      isDefault: true,
    ),
    Address(
      id: "2",
      label: "Work",
      fullAddress: "456 Corporate Blvd, Suite 200\nSan Francisco, CA 94105",
      isDefault: false,
    ),
  ].obs;

  var selectedAddress = Rx<Address?>(null);

  @override
  void onInit() {
    super.onInit();
    // Set initial selected address to default or first available
    selectedAddress.value = addresses.firstWhereOrNull((a) => a.isDefault) ?? (addresses.isNotEmpty ? addresses.first : null);
  }

  void addAddress(String label, String fullAddress) {
    if (label.isEmpty || fullAddress.isEmpty) return;
    
    final newAddress = Address(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: label,
      fullAddress: fullAddress,
      isDefault: addresses.isEmpty, // Make default if it's the first one
    );
    
    if (newAddress.isDefault) {
       for (var a in addresses) {
         a.isDefault = false;
       }
       selectedAddress.value = newAddress;
    }
    
    addresses.add(newAddress);
    // Refresh to update UI if needed (List is observable so usually auto-updates)
    if (addresses.length == 1) {
       selectedAddress.value = newAddress;
    }
    
    Get.snackbar("Success", "Address added successfully", backgroundColor: AppColors.success, colorText: Colors.white);
  }

  void deleteAddress(Address address) {
    if (address.isDefault && addresses.length > 1) {
       Get.snackbar("Error", "Cannot delete default address. Set another as default first.", backgroundColor: AppColors.error, colorText: Colors.white);
       return;
    }
    
    addresses.remove(address);
    if (selectedAddress.value == address) {
      selectedAddress.value = addresses.isNotEmpty ? addresses.first : null;
    }
  }

  void setDefault(Address address) {
    for (var a in addresses) {
      a.isDefault = false;
    }
    address.isDefault = true;
    addresses.refresh();
    selectedAddress.value = address; // Auto select default
    
    Get.snackbar("Default Updated", "${address.label} is now your default address", backgroundColor: AppColors.secondary, colorText: AppColors.primary);
  }
  
  void selectAddress(Address address) {
    selectedAddress.value = address;
  }
}
