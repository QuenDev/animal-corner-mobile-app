import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BackButtonHandler extends StatefulWidget {
  final Widget child;

  const BackButtonHandler({super.key, required this.child});

  @override
  _BackButtonHandlerState createState() => _BackButtonHandlerState();
}

class _BackButtonHandlerState extends State<BackButtonHandler> {
  DateTime? _lastPressedAt;
  bool _isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();

    // Listen for authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _isUserLoggedIn = user != null; // Update the login status
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Allow normal back navigation if the user is not logged in
        if (!_isUserLoggedIn) {
          return true;
        }

        // Handle "press back twice to exit" behavior for logged-in users
        final DateTime now = DateTime.now();
        const Duration timeout = Duration(seconds: 2);

        if (_lastPressedAt == null || now.difference(_lastPressedAt!) > timeout) {
          _lastPressedAt = now;

          // Show an exit confirmation message
          ScaffoldMessenger.of(context).clearSnackBars(); // Clear previous SnackBars
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Press back again to exit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color(0xFF424242), // Darker color for better visibility
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          return false; // Prevent immediate exit
        } else {
          SystemNavigator.pop(); // Exit the app gracefully
          return false;
        }
      },
      child: widget.child,
    );
  }
}
