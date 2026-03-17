import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/src/screens/dashboard_screen.dart';
import 'package:flutter_application_2/src/screens/forgot_password_screen.dart';
import 'package:flutter_application_2/src/screens/verifyscreen.dart';
import 'package:flutter_application_2/src/screens/terms.dart';
import 'package:flutter_application_2/src/screens/privacy.dart';
import 'package:flutter_application_2/src/utils/constants.dart';
import 'package:flutter_application_2/src/widgets/auth_header.dart';
import 'package:flutter_application_2/src/widgets/login_form.dart';
import 'package:flutter_application_2/src/widgets/signup_form.dart';
import 'package:flutter_application_2/src/services/auth_service.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _fullNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _isEmail(String input) {
    final emailExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailExp.hasMatch(input);
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final String email = _signUpEmailController.text.trim();
        final String password = _signUpPasswordController.text.trim();
        final String fullName = _fullNameController.text.trim();

        await _authService.signUp(email, password, fullName);

        _showMessage('Sign Up Successful! Please verify your email before logging in.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VerifyEmailScreen()),
        );
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
        debugPrint('Sign Up Error: $e');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final String email = _loginEmailController.text.trim();
        final String password = _loginPasswordController.text.trim();

        UserCredential? userCredential = await _authService.signIn(email, password);

        final User? user = userCredential?.user;
        if (user != null) {
          await user.reload();
          bool emailVerified = user.emailVerified;

          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            if (emailVerified && (userDoc['emailVerified'] == true)) {
              _showMessage('Login successful!');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(currentIndex: 0),
                ),
              );
            } else if (!emailVerified) {
              _showMessage('Please verify your email before logging in.');
              await _authService.signOut();
            }
          } else {
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const AuthHeader(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTabButton('Sign Up', isSignUp, () => setState(() => isSignUp = true)),
                          const SizedBox(width: 20),
                          _buildTabButton('Log In', !isSignUp, () => setState(() => isSignUp = false)),
                        ],
                      ),
                      const SizedBox(height: 30),
                      if (isSignUp)
                        SignUpForm(
                          fullNameController: _fullNameController,
                          emailController: _signUpEmailController,
                          passwordController: _signUpPasswordController,
                          passwordVisible: passwordVisible,
                          isLoading: isLoading,
                          onTogglePasswordVisibility: () => setState(() => passwordVisible = !passwordVisible),
                          onSignUp: _signUp,
                          onLoginRedirect: () => setState(() => isSignUp = false),
                          onTermsTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsScreen())),
                          onPrivacyTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen())),
                          emailValidator: _isEmail,
                        )
                      else
                        LoginForm(
                          emailController: _loginEmailController,
                          passwordController: _loginPasswordController,
                          passwordVisible: passwordVisible,
                          isLoading: isLoading,
                          onTogglePasswordVisibility: () => setState(() => passwordVisible = !passwordVisible),
                          onLogin: _signIn,
                          onForgotPassword: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())),
                          emailValidator: _isEmail,
                        ),
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

  Widget _buildTabButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: AppColors.primaryGreen),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
