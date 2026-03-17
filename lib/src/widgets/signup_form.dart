import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_application_2/src/utils/constants.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool passwordVisible;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onSignUp;
  final VoidCallback onLoginRedirect;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;
  final bool Function(String) emailValidator;

  const SignUpForm({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisible,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onSignUp,
    required this.onLoginRedirect,
    required this.onTermsTap,
    required this.onPrivacyTap,
    required this.emailValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Create Account',
          style: AppStyles.formTitle,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: fullNameController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person, color: AppColors.primaryGreen),
            labelText: 'Full Name',
            labelStyle: TextStyle(color: AppColors.primaryGreen),
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
          controller: emailController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email, color: AppColors.primaryGreen),
            labelText: 'Email Address',
            labelStyle: TextStyle(color: AppColors.primaryGreen),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty || !emailValidator(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: passwordController,
          obscureText: !passwordVisible,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock, color: AppColors.primaryGreen),
            labelText: 'Password',
            labelStyle: const TextStyle(color: AppColors.primaryGreen),
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible ? Icons.visibility_off : Icons.visibility,
                color: AppColors.primaryGreen,
              ),
              onPressed: onTogglePasswordVisibility,
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
        isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: onSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: const BorderSide(color: AppColors.primaryGreen),
                ),
                child: const Text('Sign Up', style: AppStyles.buttonText),
              ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onLoginRedirect,
          child: const Text(
            'Already have an account? Log In',
            style: AppStyles.linkText,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                children: [
                  const TextSpan(text: 'By signing up, you agree to Animal Corner\'s '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = onTermsTap,
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = onPrivacyTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
