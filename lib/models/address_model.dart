class Address {
  String id;
  String label; // e.g., "Home", "Work"
  String fullAddress;
  bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.fullAddress,
    this.isDefault = false,
  });
}
