import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appointment_model.dart';
import 'dart:math';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference _getUserAppointments() {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    return _firestore.collection('users').doc(user.uid).collection('appointments');
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    try {
      final ref = _getUserAppointments();
      int uniqueId = await _generateUniqueId();
      
      final data = appointment.toMap();
      data['appointment_id'] = uniqueId;

      await ref.add(data);
    } catch (e) {
      print("Error adding appointment: $e");
      rethrow;
    }
  }

  Future<List<AppointmentModel>> getAppointmentsByStatus(String status) async {
    try {
      final ref = _getUserAppointments();
      final snapshot = await ref
          .where('status', isEqualTo: status)
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs.map((doc) => AppointmentModel.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error getting appointments: $e");
      rethrow;
    }
  }

  Future<void> updateAppointmentStatus(String docId, String status) async {
    try {
      final ref = _getUserAppointments();
      await ref.doc(docId).update({'status': status});
    } catch (e) {
      print("Error updating status: $e");
      rethrow;
    }
  }

  Future<int> _generateUniqueId() async {
    final ref = _getUserAppointments();
    Random random = Random();
    int id;
    bool isUnique = false;

    do {
      id = random.nextInt(9900) + 100;
      final snapshot = await ref.where('appointment_id', isEqualTo: id).get();
      if (snapshot.docs.isEmpty) isUnique = true;
    } while (!isUnique);

    return id;
  }
}
