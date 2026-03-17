import 'package:flutter/material.dart';
import 'package:flutter_application_2/src/utils/constants.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool passwordVisible;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final bool Function(String) emailValidator;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisible,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onLogin,
    required this.onForgotPassword,
    required this.emailValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Log In',
          style: AppStyles.formTitle,
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
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: const BorderSide(color: AppColors.primaryGreen),
                ),
                child: const Text('Log In', style: AppStyles.buttonText),
              ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: onForgotPassword,
          child: const Text(
            'Forgot Password?',
            style: AppStyles.linkText,
          ),
        ),
      ],
    );
  }
}
