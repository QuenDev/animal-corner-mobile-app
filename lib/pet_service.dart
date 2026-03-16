import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> savePetToFirebase(Map<String, dynamic> petDetails) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Save the pet data under the user's collection
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .add(petDetails);
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      // Handle any errors here
      print("Error saving pet to Firebase: $e");
    }
  }
  Future<void> updatePetToFirebase(String petId, Map<String, dynamic> petDetails) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('pets')
          .doc(petId)
          .update(petDetails);
    }
  }

  // New method to retrieve pets for the currently logged-in user
  Future<List<Map<String, dynamic>>> getUserPets() async {
    User? user = _auth.currentUser;
    List<Map<String, dynamic>> pets = [];

    if (user != null) {
      try {
        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .get();

        pets = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      } catch (e) {
        print("Error retrieving user's pets: $e");
      }
    } else {
      throw Exception("User not logged in");
    }

    return pets;
  }
}
