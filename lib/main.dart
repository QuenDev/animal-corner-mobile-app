import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/dashboard_screen.dart';
import 'package:flutter_application_2/home_screen.dart';
import 'package:flutter_application_2/profile_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAZSKEdw0n52mHffa32cx3igFUW3A1O0XI",
          authDomain: "pet-application-final.firebaseapp.com",
          projectId: "pet-application-final",
          storageBucket: "pet-application-final.appspot.com",
          messagingSenderId: "179423395003",
          appId: "1:179423395003:web:f0421078594e6f7e963d9e",
          measurementId: "G-LHNTXM9PJ7",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    // Enable Firestore offline persistence after Firebase initialization
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );

    // Load profile data asynchronously
    await ProfileService.loadProfileData();

    // Run the app only after initialization is complete
    runApp(const AnimalCorner());
  } catch (e) {
    // Handle any errors during initialization
    debugPrint("Error initializing Firebase: $e");
  }
}

class AnimalCorner extends StatelessWidget {
  const AnimalCorner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state changes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while checking authentication state
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            final User? user = snapshot.data;

            // Check if user is logged in and their email is verified
            if (user != null) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (userSnapshot.hasData) {
                    final userDoc = userSnapshot.data!;
                    final emailVerified = userDoc['emailVerified'] ?? false;

                    if (emailVerified && user.emailVerified) {
                      // Verified user, proceed to Dashboard
                      return const DashboardScreen(currentIndex: 0);
                    } else {
                      // Unverified user, sign them out
                      FirebaseAuth.instance.signOut();
                      return const HomeScreen();
                    }
                  } else {
                    // User data not found, fallback to HomeScreen
                    FirebaseAuth.instance.signOut();
                    return const HomeScreen();
                  }
                },
              );
            }
          }

          // If no user is logged in, show the HomeScreen
          return const HomeScreen();
        },
      ),
    );
  }
}
