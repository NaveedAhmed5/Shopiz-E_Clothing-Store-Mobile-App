import 'cart_item_model.dart';

enum OrderStatus {
  processing,
  delivered,
  cancelled
}

class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double totalAmount;
  OrderStatus status;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
    this.status = OrderStatus.processing,
  });
}
