import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyLoginScreen extends StatefulWidget {
  const VerifyLoginScreen({super.key});

  @override
  _VerifyLoginScreenState createState() => _VerifyLoginScreenState();
}

class _VerifyLoginScreenState extends State<VerifyLoginScreen> {
  @override
  void initState() {
    super.initState();
    _checkEmailVerificationPeriodically();
  }

  void _checkEmailVerificationPeriodically() {
    Future.delayed(const Duration(seconds: 5), () async {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          // Update emailVerified field in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'emailVerified': true});

          // Redirect to Welcome screen
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          }
        } else {
          // Repeat the check if the user hasn't verified their email yet
          _checkEmailVerificationPeriodically();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable the back button
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Complete the verification process to proceed.'),
          ),
        );
        return false; // Prevent back navigation
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F5E9), // Consistent background color
        appBar: AppBar(
          automaticallyImplyLeading: false, // Disable back button in AppBar
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'Verify Your Email',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Email Verification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'A verification email has been sent to your email address. '
                  'Please verify your email to continue. Once verified, you will '
                  'be redirected to the log in automatically.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
