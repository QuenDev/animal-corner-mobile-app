import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/pet_model.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> savePetToFirebase(PetModel pet) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .add(pet.toMap());
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      print("Error saving pet to Firebase: $e");
      rethrow;
    }
  }

  Future<void> updatePetToFirebase(PetModel pet) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .doc(pet.id)
            .update(pet.toMap());
      }
    } catch (e) {
      print("Error updating pet: $e");
      rethrow;
    }
  }

  Future<List<PetModel>> getUserPets() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('pets')
            .get();

        return snapshot.docs.map((doc) => PetModel.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
      } catch (e) {
        print("Error retrieving user's pets: $e");
        rethrow;
      }
    } else {
      throw Exception("User not logged in");
    }
  }
}
