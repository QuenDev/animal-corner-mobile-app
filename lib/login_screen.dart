
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/dashboard_screen.dart';
import 'package:flutter_application_2/forgot_password_screen.dart';
import 'package:flutter_application_2/verifyscreen.dart';
import 'package:flutter_application_2/terms.dart'; // Import your new screens
import 'package:flutter_application_2/privacy.dart'; // Import your new screens
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  bool isLoading = false;
  bool isSignUp = true;
  bool passwordVisible = false;
  final bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  // Show message function
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Email validation function
  bool _isEmail(String input) {
    final emailExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailExp.hasMatch(input);
  }

  // ----------------------- Sign Up Function -----------------------
  Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final String email = _signUpEmailController.text.trim();
        final String password = _signUpPasswordController.text.trim();
        final String fullName = _fullNameController.text.trim();

        // Create user with email and password
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final User? user = userCredential.user;

        if (user != null) {
          // Send email verification
          await user.sendEmailVerification();

          // Save additional user info to Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'fullName': fullName,
            'email': email,
            'createdAt': Timestamp.now(),
            'emailVerified': false,
          });

          _showMessage(
              'Sign Up Successful! Please verify your email before logging in.');

          // Navigate to "Verify Email" screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const VerifyEmailScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'An error occurred during sign-up.';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'This email is already in use. Please use a different one.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        }
        _showMessage(errorMessage);
      } catch (e) {
        _showMessage('An unexpected error occurred. Please try again.');
        print('Sign Up Error: $e');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  // ----------------------- Sign In Function -----------------------
  Future<void> _signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final String email = _loginEmailController.text.trim();
        final String password = _loginPasswordController.text.trim();

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final User? user = userCredential.user;

        if (user != null) {
          await user.reload(); // Refresh user info
          bool emailVerified = user.emailVerified;

          print('User UID: ${user.uid}');
          print('Email Verified: $emailVerified');

          // Check Firestore document
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            print('User document found in Firestore: ${userDoc.data()}');

            // Check if email is verified in Firestore
            if (emailVerified && (userDoc['emailVerified'] == true)) {
              // Show success message
              _showMessage('Login successful!');

              // Navigate to Dashboard
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(currentIndex: 0),
                ),
              );
            } else if (!emailVerified) {
              _showMessage('Please verify your email before logging in.');
              FirebaseAuth.instance.signOut();
            }
          } else {
            print('Error: Firestore document for UID ${user.uid} does not exist.');
            _showMessage('User data not found. Please contact support.');
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Incorrect email or password, please try again.';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email address.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password. Please try again.';
        }
        _showMessage(errorMessage);
      } catch (e) {
        _showMessage('An unexpected error occurred: $e');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFE8F5E9),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header section with logo and title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Animal Corner',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Authentication Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Switch between Sign Up and Log In views
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignUp = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                            decoration: BoxDecoration(
                              color: isSignUp ? const Color(0xFF2E7D32) : Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: const Color(0xFF2E7D32)),
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: isSignUp ? Colors.white : const Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignUp = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                            decoration: BoxDecoration(
                              color: !isSignUp ? const Color(0xFF2E7D32) : Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: const Color(0xFF2E7D32)),
                            ),
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                color: !isSignUp ? Colors.white : const Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (isSignUp) ...[
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Color(0xFF2E7D32)),
                          labelText: 'Full Name',
                          labelStyle: TextStyle(color: Color(0xFF2E7D32)),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _signUpEmailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Color(0xFF2E7D32)),
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: Color(0xFF2E7D32)),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty || !_isEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _signUpPasswordController,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF2E7D32)),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible ? Icons.visibility_off : Icons.visibility,
                              color: const Color(0xFF2E7D32),
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      _isLoading // Show loading spinner when loading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () => _signUp(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF2E7D32),
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                side: const BorderSide(color: Color(0xFF2E7D32)),
                              ),
                              child: const Text('Sign Up', style: TextStyle(fontSize: 14)),
                            ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignUp = false;
                          });
                        },
                        child: const Text(
                          'Already have an account? Log In',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                       const SizedBox(height: 10),
  // Terms and Conditions link (this part goes at the bottom and is centered)
 Padding(
  padding: const EdgeInsets.only(top: 180.0), // Add some space from other elements
  child: Center(
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          color: Color(0xFF2E7D32),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        children: [
          const TextSpan(text: 'By signing up, you agree to Animal Corner\'s '),
          TextSpan(
            text: 'Terms of Service',
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Navigate to Terms of Service screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsScreen()),
                );
              },
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Navigate to Privacy Policy screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                );
              },
          ),
        ],
      ),
    ),
  ),
),
],
                    if (!isSignUp) ...[
                      const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _loginEmailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Color(0xFF2E7D32)),
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: Color(0xFF2E7D32)),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty || !_isEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _loginPasswordController,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF2E7D32)),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible ? Icons.visibility_off : Icons.visibility,
                              color: const Color(0xFF2E7D32),
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      _isLoading // Show loading spinner when loading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () => _signIn(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF2E7D32),
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                side: const BorderSide(color: Color(0xFF2E7D32)),
                              ),
                              child: const Text('Log In', style: TextStyle(fontSize: 14)),
                            ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPasswordScreen()),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
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
