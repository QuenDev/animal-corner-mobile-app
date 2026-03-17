import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<UserCredential?> signUp(String email, String password, String fullName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        await user.sendEmailVerification();
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'email': email,
          'uid': user.uid,
          'created_at': FieldValue.serverTimestamp(),
          'emailVerified': false,
        });
      }
      return result;
    } catch (e) {
      print("Sign up error: $e");
      rethrow;
    }
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Sign in error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null && user.email != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    }
  }

  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    }
    return false;
  }

  Future<DocumentSnapshot?> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return await _firestore.collection('users').doc(user.uid).get();
    }
    return null;
  }
}
