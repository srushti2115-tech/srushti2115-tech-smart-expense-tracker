import 'package:flutter/material.dart';

class CategoryStyle {
  static const Map<String, Color> colors = {
    "Food": Color(0xFFE57373),      // Red
    "Travel": Color(0xFF64B5F6),    // Blue
    "Shopping": Color(0xFFBA68C8),  // Purple
    "Rent": Color(0xFF4DB6AC),      // Teal
    "Bills": Color(0xFFFFB74D),     // Orange
    "Other": Color(0xFFA1887F),     // Brown
  };

  static const Map<String, IconData> icons = {
    "Food": Icons.restaurant,
    "Travel": Icons.directions_car,
    "Shopping": Icons.shopping_bag,
    "Rent": Icons.home,
    "Bills": Icons.receipt_long,
    "Other": Icons.category,
  };
}
