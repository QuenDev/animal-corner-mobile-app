import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Map<String, String?>> loadProfileData() async {
    User? user = _auth.currentUser;
    String name = '';
    String phone = '';
    String address = '';
    String? profileImage;

    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return {
          'owner_name': data['fullName'] ?? '', // Fetch fullName instead of owner_name
          'owner_phone': data['owner_phone'] ?? '',
          'owner_address': data['owner_address'] ?? '',
          'profile_image': data['imagePath'] ?? '', // Ensure to fetch the imagePath
        };
      }
    }
    return {'owner_name': name, 'owner_phone': phone, 'owner_address': address, 'profile_image': profileImage};
  }

  static Future<void> saveProfileData(String name, String phone, String address, String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    User? user = _auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      await prefs.setString('${uid}_owner_name', name);
      await prefs.setString('${uid}_owner_phone', phone);
      await prefs.setString('${uid}_owner_address', address);
      
      if (imagePath != null && imagePath.isNotEmpty) {
        await prefs.setString('${uid}_profile_image', imagePath); // Save to SharedPreferences
      }

      // Save the profile data including the image path to Firestore
      await _firestore.collection('users').doc(uid).set({
        'fullName': name, // Ensure to save under 'fullName'
        'owner_phone': phone,
        'owner_address': address,
        'imagePath': imagePath, // Save the image path correctly
      }, SetOptions(merge: true));
    }
  }
}