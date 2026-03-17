import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class ProfileService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserModel?> loadProfileData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        data['email'] = user.email; // Ensure email is present
        return UserModel.fromMap(uid, data);
      }
    }
    return null;
  }

  static Future<void> saveProfileData(UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    User? user = _auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      await prefs.setString('${uid}_owner_name', userModel.fullName);
      await prefs.setString('${uid}_owner_phone', userModel.phone);
      await prefs.setString('${uid}_owner_address', userModel.address);
      
      if (userModel.imagePath != null && userModel.imagePath!.isNotEmpty) {
        await prefs.setString('${uid}_profile_image', userModel.imagePath!);
      }

      await _firestore.collection('users').doc(uid).set(
        userModel.toMap(),
        SetOptions(merge: true),
      );
    }
  }
}