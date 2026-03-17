import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFE8F5E9);
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color secondaryGreen = Color(0xFF66BB6A);
}

class AppStyles {
  static const TextStyle headerTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle formTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryGreen,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
  );

  static const TextStyle linkText = TextStyle(
    color: AppColors.primaryGreen,
    fontWeight: FontWeight.bold,
  );
}
