import 'package:flutter/material.dart';
import 'package:flutter_application_2/login_screen.dart'; // Import your login screen here


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light green background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header with logo and title (replace with actual images later)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    // Placeholder for logo
                    Icon(
                      Icons.pets,
                      size: 80,
                      color: Color(0xFF2E7D32), // Dark green for icon
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Animal Corner', // Title
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32), // Dark green text
                      ),
                    ),
                  ],
                ),
              ),
              
              // Image placeholders (replace with actual images later)
             Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Image for cat
    CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: Image.asset(
          'assets/cat.png',  // Change this path to your cat image
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    ),
    const SizedBox(width: 30),
    // Image for dog
    CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: Image.asset(
          'assets/dog.png',  // Change this path to your dog image
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    ),
  ],
),

              const SizedBox(height: 30),
              
              // Welcome message
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32), // Dark green text
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'You have successfully signed up. Please Log in to Proceed to the Dashboard.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2E7D32), // Dark green text
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Continue button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66BB6A), // Light green button color
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
