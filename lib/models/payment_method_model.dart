class PaymentMethod {
  String id;
  String cardNumber; // e.g., "**** **** **** 1234"
  String cardHolderName;
  String expiryDate;
  bool isDefault;

  PaymentMethod({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    this.isDefault = false,
  });
}
