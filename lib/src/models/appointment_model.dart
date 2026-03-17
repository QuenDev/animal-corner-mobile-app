import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final int appointmentId;
  final String name;
  final String pet;
  final String service;
  final String day;
  final String timeSlot;
  final String status;
  final DateTime? createdAt;

  AppointmentModel({
    required this.id,
    required this.appointmentId,
    required this.name,
    required this.pet,
    required this.service,
    required this.day,
    required this.timeSlot,
    required this.status,
    this.createdAt,
  });

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      appointmentId: data['appointment_id'] ?? 0,
      name: data['appointment_name'] ?? '',
      pet: data['pet'] ?? '',
      service: data['service'] ?? '',
      day: data['day'] ?? '',
      timeSlot: data['time_slot'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointment_id': appointmentId,
      'appointment_name': name,
      'pet': pet,
      'service': service,
      'day': day,
      'time_slot': timeSlot,
      'status': status,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
