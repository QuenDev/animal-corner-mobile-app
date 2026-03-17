import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_2/src/screens/login_screen.dart';
import 'package:flutter_application_2/src/services/auth_service.dart';
import 'package:flutter_application_2/src/services/profile_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

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

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );

    await ProfileService.loadProfileData();

    runApp(const AnimalCorner());
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }
}

class AnimalCorner extends StatelessWidget {
  const AnimalCorner({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            return FutureBuilder<DocumentSnapshot?>(
              future: authService.getUserData(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (userSnapshot.hasData && userSnapshot.data != null) {
                  final userDoc = userSnapshot.data!;
                  final emailVerifiedInDb = userDoc['emailVerified'] ?? false;
                  final user = snapshot.data!;

                  if (emailVerifiedInDb && user.emailVerified) {
                    return const DashboardScreen(currentIndex: 0);
                  } else {
                    authService.signOut();
                    return const LoginScreen();
                  }
                }
                
                authService.signOut();
                return const LoginScreen();
              },
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
