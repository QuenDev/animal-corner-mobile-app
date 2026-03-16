// TermsOfServiceScreen.dart
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green, // Green theme for AppBar
        title: const Text(
          'Terms of Service',
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
              // Title
              Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E7D32), // Green color
                ),
              ),
              const SizedBox(height: 20),

              // Section 1: Introduction
              Text(
                '1. Introduction',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF388E3C), // Slightly darker green
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Welcome to Animal Corner! By accessing or using our app, you agree to be bound by these Terms of Service and our Privacy Policy. If you do not agree with these terms, please do not use our app.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Section 2: Account Registration
              Text(
                '2. Account Registration',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF388E3C), // Green header
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'To use the services of Animal Corner, you must register for an account. You agree to provide accurate and complete information during the registration process and update it if necessary.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Section 3: User Responsibilities
              Text(
                '3. User Responsibilities',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF388E3C), // Green header
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'As a user, you agree to use our services responsibly. You are prohibited from using Animal Corner for any unlawful activities, including but not limited to:'
                '\n\n- Engaging in illegal or harmful activities'
                '\n- Distributing malicious software or viruses'
                '\n- Harassing other users or violating their rights',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Section 4: Privacy and Data Collection
              Text(
                '4. Privacy and Data Collection',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF388E3C), // Green header
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'We value your privacy. Our app collects personal information such as your name, email address, and usage data to improve our services. We are committed to protecting your privacy and will not share your information with third parties without your consent. For more information, please refer to our Privacy Policy.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Section 5: Intellectual Property
              Text(
                '5. Intellectual Property',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF388E3C), // Green header
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'All content available on Animal Corner, including but not limited to text, images, logos, graphics, and software, is the property of Animal Corner and protected by copyright laws. You may not use, reproduce, or distribute any content from the app without our permission.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Section 6: Termination
              Text(
                '6. Termination',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF388E3C), // Green header
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'We reserve the right to suspend or terminate your account if you violate any of these Terms of Service. Upon termination, you will no longer have access to our services, and we may delete your account and data.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Section 7: Limitation of Liability
              Text(
                '7. Limitation of Liability',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF388E3C), // Green header
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Animal Corner is not responsible for any damages, losses, or liabilities that may arise from using our app, including but not limited to:'
                '\n\n- Any interruption or failure of services'
                '\n- Loss of data or user-generated content'
                '\n- Any errors or inaccuracies in the app',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Section 8: Governing Law
              Text(
                '8. Governing Law',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF388E3C), // Green header
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'These Terms of Service are governed by the laws of the jurisdiction in which Animal Corner operates. Any disputes arising from these terms will be resolved in the courts of that jurisdiction.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Section 9: Modifications
              Text(
                '9. Modifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF388E3C), // Green header
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'We reserve the right to modify or update these Terms of Service at any time. Any changes will be posted on this page, and the date of the most recent update will be indicated at the bottom of the page. You are encouraged to review these terms periodically.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Section 10: Contact Us
              Text(
                '10. Contact Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF388E3C), // Green header
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'If you have any questions or concerns about these Terms of Service, please contact us at support@animalcorner.com.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Last Updated Date
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
