import 'package:flutter/material.dart';

class Service {
  final String name;
  final IconData icon;

  Service({required this.name, required this.icon});
}

class PetCareNews {
  final String title;
  final String description;
  final IconData icon;

  PetCareNews({required this.title, required this.description, required this.icon});
}

class NotificationItem {
  final String title;
  final String description;

  NotificationItem({required this.title, required this.description});
}
