import 'package:get/get.dart';
import '../models/payment_method_model.dart';
import '../constants.dart';
import 'package:flutter/material.dart';

class PaymentController extends GetxController {
  var paymentMethods = <PaymentMethod>[
    PaymentMethod(
      id: "1",
      cardNumber: "**** **** **** 4242",
      cardHolderName: "John Doe",
      expiryDate: "12/25",
      isDefault: true,
    ),
    PaymentMethod(
      id: "2",
      cardNumber: "**** **** **** 8888",
      cardHolderName: "John Doe",
      expiryDate: "09/26",
      isDefault: false,
    ),
  ].obs;

  var selectedPaymentMethod = Rx<PaymentMethod?>(null);

  @override
  void onInit() {
    super.onInit();
    selectedPaymentMethod.value = paymentMethods.firstWhereOrNull((p) => p.isDefault) ?? (paymentMethods.isNotEmpty ? paymentMethods.first : null);
  }

  void addPaymentMethod(String cardNumber, String holderName, String expiry) {
    if (cardNumber.isEmpty || holderName.isEmpty || expiry.isEmpty) return;
    
    // Simple mask for demo roughly last 4 digits
    String masked = cardNumber.length > 4 
      ? "**** **** **** ${cardNumber.substring(cardNumber.length - 4)}" 
      : cardNumber;

    final newMethod = PaymentMethod(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardNumber: masked,
      cardHolderName: holderName,
      expiryDate: expiry,
      isDefault: paymentMethods.isEmpty,
    );
    
    if (newMethod.isDefault) {
       for (var p in paymentMethods) {
         p.isDefault = false;
       }
       selectedPaymentMethod.value = newMethod;
    }
    
    paymentMethods.add(newMethod);
    if (paymentMethods.length == 1) {
       selectedPaymentMethod.value = newMethod;
    }
    
    Get.snackbar("Success", "Card added successfully", backgroundColor: AppColors.success, colorText: Colors.white);
  }

  void deletePaymentMethod(PaymentMethod method) {
    if (method.isDefault && paymentMethods.length > 1) {
       Get.snackbar("Error", "Cannot delete default payment method. Set another as default first.", backgroundColor: AppColors.error, colorText: Colors.white);
       return;
    }
    
    paymentMethods.remove(method);
    if (selectedPaymentMethod.value == method) {
      selectedPaymentMethod.value = paymentMethods.isNotEmpty ? paymentMethods.first : null;
    }
  }

  void setDefault(PaymentMethod method) {
    for (var p in paymentMethods) {
      p.isDefault = false;
    }
    method.isDefault = true;
    paymentMethods.refresh();
    selectedPaymentMethod.value = method;
    
    Get.snackbar("Default Updated", "Card ending in ${method.cardNumber.substring(method.cardNumber.length - 4)} is now default", backgroundColor: AppColors.secondary, colorText: AppColors.primary);
  }
  
  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
  }
}
