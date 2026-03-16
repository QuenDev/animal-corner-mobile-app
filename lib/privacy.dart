// PrivacyPolicyScreen.dart
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green, // Green theme for AppBar
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Green theme for the title
                ),
              ),
              SizedBox(height: 20),
              Text(
                '1. Introduction',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Green color for section titles
                ),
              ),
              SizedBox(height: 10),
              Text(
                'At Animal Corner, we value your privacy and are committed to protecting the personal information you share with us. This Privacy Policy outlines how we collect, use, store, and safeguard your information when you use our mobile app. By using Animal Corner, you agree to the practices described in this policy.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '2. Information We Collect',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We collect the following types of information when you use our app:'
                '\n\n- **Personal Information**: When you register for an account, we collect personal details such as your name, email address, and phone number.'
                '\n- **Usage Data**: We collect data on how you interact with the app, including the features you use, the time you spend on the app, and the pages you visit.'
                '\n- **Location Data**: With your consent, we collect location data to provide location-based features and services.'
                '\n- **Device Information**: We collect information about your device, such as its model, operating system, and IP address.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '3. How We Use Your Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We use the information we collect to improve and personalize your experience with Animal Corner, including:'
                '\n\n- To provide and maintain the app’s services'
                '\n- To personalize content and recommendations'
                '\n- To communicate with you regarding account updates, promotions, and news'
                '\n- To improve the functionality and performance of our app'
                '\n- To monitor and analyze app usage and user behavior'
                '\n- To prevent fraudulent activities and ensure the security of our services.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '4. How We Protect Your Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We take the security of your personal information seriously and implement various measures to protect it from unauthorized access, use, or disclosure. These measures include:'
                '\n\n- **Encryption**: Sensitive data, such as login credentials and payment information, is encrypted during transmission.'
                '\n- **Access Control**: Only authorized personnel have access to your data.'
                '\n- **Regular Audits**: We regularly audit our security practices to identify and mitigate potential risks.'
                '\n\nDespite these efforts, no system can be completely secure, and we cannot guarantee the absolute security of your data.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '5. Sharing Your Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We do not sell, trade, or rent your personal information to third parties. However, we may share your information with trusted third-party service providers who assist us in operating the app, conducting business, or providing services to you, such as:'
                '\n\n- Cloud storage providers'
                '\n- Analytics and data processing companies'
                '\n- Payment processors'
                '\n- Advertising and marketing partners',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '6. Your Rights and Choices',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'You have the right to:'
                '\n\n- **Access**: You can request a copy of the personal information we hold about you.'
                '\n- **Update or Correct**: You can update or correct your personal information at any time.'
                '\n- **Delete**: You can request the deletion of your account and personal data, subject to legal requirements.'
                '\n- **Opt-Out**: You can opt-out of marketing communications by following the unsubscribe instructions provided in each communication.'
                '\n\nTo exercise these rights, please contact us at the contact information provided below.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '7. Cookies and Tracking Technologies',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We use cookies and similar tracking technologies to enhance your experience on our app. Cookies are small files stored on your device that help us remember your preferences, analyze usage patterns, and provide personalized content. You can choose to disable cookies in your device settings, but doing so may affect the functionality of certain features within the app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '8. Children\'s Privacy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Our app is not intended for children under the age of 13, and we do not knowingly collect personal information from children. If we discover that we have collected personal information from a child under 13, we will take steps to delete that information as soon as possible.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '9. Changes to This Privacy Policy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We may update this Privacy Policy from time to time. Any changes will be posted on this page, and the effective date will be updated at the bottom of the policy. We encourage you to review this policy periodically to stay informed about how we protect your information.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '10. Contact Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'If you have any questions or concerns about this Privacy Policy, please contact us at support@animalcorner.com.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
               Text(
                'Last Updated: December 2024',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF2E7D32), // Green date
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
