import 'package:flutter/material.dart';
import 'package:flutter_application_2/src/utils/constants.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondaryGreen, AppColors.primaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: const Column(
        children: [
          Text(
            'Animal Corner',
            style: AppStyles.headerTitle,
          ),
        ],
      ),
    );
  }
}
