import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      _showMessage('Please enter your email address');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Check if the email exists in Firebase Authentication
      List<String> methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
        _emailController.text.trim(),
      );

      if (methods.isEmpty) {
        // If no methods are returned, it means the email is not registered
        _showMessage('No account found with this email address.');
      } else {
        // If methods are found, proceed with the password reset
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        _showMessage('Password reset email sent! Check your inbox.');
        Navigator.pop(context); // Go back to the login screen
      }
    } catch (e) {
      _showMessage('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
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
          "Forgot Password",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Changed to white
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Reset your Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Color(0xFF2E7D32)),
                  labelText: 'Email Address',
                  labelStyle: TextStyle(color: Color(0xFF2E7D32)),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
