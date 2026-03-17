import 'package:flutter/material.dart';

class LegalDialogs {
  static void showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Privacy Policy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.green,
            ),
          ),
          content: SizedBox(
            width: 400,
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Effective Date: December 2024\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('1. Introduction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('At Animal Corner, we value your privacy and are committed to protecting the personal information you share with us...\n'),
                  Text('2. Information We Collect', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('- Personal Information: Name, email, phone number.\n- Usage Data: How you interact with the app.\n- Location Data: With your consent, for location-based features.\n- Device Information: Model, OS, and IP address.\n'),
                  Text('3. How We Use Your Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('- To provide and maintain the app’s services\n- To personalize content and recommendations\n- To prevent fraudulent activities.\n'),
                  Text('4. Data Security', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('We implement encryption and access controls to protect your data, though no system is 100% secure.\n'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  static void showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Terms of Service',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.green,
            ),
          ),
          content: SizedBox(
            width: 400,
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Last Updated: December 2024\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('1. Introduction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('By accessing or using Animal Corner, you agree to be bound by these Terms of Service.\n'),
                  Text('2. Account Registration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('You must provide accurate information during registration and keep it updated.\n'),
                  Text('3. User Responsibilities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('You are prohibited from using the app for unlawful activities, harassment, or distributing malicious software.\n'),
                  Text('4. Limitation of Liability', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('Animal Corner is not responsible for any damages or losses arising from the use of our services.\n'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.green)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
