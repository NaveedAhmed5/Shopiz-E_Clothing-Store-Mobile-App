import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  
  // Updated: Supports up to 10 images
  final List<String> imageUrls; 
  
  // Specific Attributes
  final String gender;      // Men, Women, Juniors (Girl, Boy, Baby)
  final String category;    // Clothes, Watches, Belts, Perfumes
  final String subCategory; // T-Shirts, Jeans, Analog, etc.
  final String season;      // Summer, Winter, All-Season
  
  final List<String> sizes;
  final List<Color> colors;
  final double rating;
  final DateTime dateAdded;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrls,
    required this.gender,
    required this.category,
    required this.subCategory,
    required this.season,
    required this.sizes,
    required this.colors,
    required this.rating,
    required this.dateAdded,
  });
  
  // Helper to check if item is on sale
  bool get isOnSale => originalPrice != null && originalPrice! > price;
  
  // Helper to calculate discount percentage
  int get discountPercent {
    if (!isOnSale) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).round();
  }
}