import 'package:get/get.dart';
import 'product_model.dart';

class CartItem {
  final Product product;
  final String selectedSize;
  final int selectedColorIndex;
  RxInt quantity; // Observable for real-time updates

  CartItem({
    required this.product,
    required this.selectedSize,
    required this.selectedColorIndex,
    int quantity = 1,
  }) : quantity = quantity.obs;

  double get totalPrice => product.price * quantity.value;
}
