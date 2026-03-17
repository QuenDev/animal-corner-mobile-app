import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_2/src/screens/pet_profile.dart';
import 'package:flutter_application_2/src/screens/history_screen.dart';
import 'package:flutter_application_2/src/screens/dashboard_screen.dart';
import 'package:flutter_application_2/src/screens/search_screen.dart';
import 'package:flutter_application_2/src/screens/notif_screen.dart';
import 'package:flutter_application_2/src/screens/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter_application_2/src/widgets/back_button.dart';
import 'package:flutter_application_2/src/widgets/app_bottom_nav.dart';
import 'package:flutter_application_2/src/utils/constants.dart';
import 'package:flutter_application_2/src/services/appointment_service.dart';
import 'package:flutter_application_2/src/models/appointment_model.dart';

class ScheduleScreen extends StatefulWidget {
  final int currentIndex;

  const ScheduleScreen({super.key, required this.currentIndex});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}



class _ScheduleScreenState extends State<ScheduleScreen> {
  late int _currentPage;
  final TextEditingController _nameController = TextEditingController();
  final AppointmentService _appointmentService = AppointmentService();

  final List<String> availableDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  final Map<String, List<String>> availableTimeSlots = {
    'Morning': ['9:00 AM', '10:00 AM', '11:00 AM'],
    'Afternoon': ['12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM'],
    'Evening': ['4:00 PM', '5:00 PM', '6:00 PM'],
  };

  final List<String> services = [
    'Consultations',
    'Emergency Cases',
    'Grooming',
    'Vaccinations',
    'Deworming',
    'Surgery',
    'Dog & Cat Hotel',
    'Confinement',
    'Pet Pharmacy',
    'Stud Services'
  ];

  String? selectedService;
  String? selectedDay;
  String? selectedTimeSlot;
  String? selectedPeriod;
  String? selectedPet; // New variable for selected pet

  bool _isSaving = false; // To manage saving state
  List<String> userPets = []; // List to hold the user's pets

  late Timer _statusUpdateTimer;


  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex;
    _loadUserPets();
    _loadUserName();
    // Start a timer to update appointment status every minute
    _statusUpdateTimer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {

      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusUpdateTimer.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _loadUserName() async {
    try {
      DocumentSnapshot? userSnapshot = await AuthService().getUserData();

      if (userSnapshot != null && userSnapshot.exists) {
        setState(() {
          _nameController.text = userSnapshot['fullName'];
        });
      }
    } catch (e) {
      print('Error loading user name: $e');
    }
  }

  Future<void> _loadUserPets() async {
    try {
      List<PetModel> pets = await PetService().getPets();
      setState(() {
        userPets = pets.map((pet) => pet.name).toList();
      });
    } catch (e) {
      print('Error loading user pets: $e');
    }
  }


  DateTime _parseAppointmentDateTime(String day, String timeSlot) {
    try {
      // Parse the day into a DateTime object
      DateTime datePart = DateTime.parse(day); // This will work if day is in YYYY-MM-DD format

      // Parse the timeSlot into DateTime format
      final timeFormat = DateFormat.jm(); // Use 'jm' format for "2:00 PM" style strings
      DateTime timePart = timeFormat.parse(timeSlot);

      // Combine date and time parts to create a DateTime object for the appointment
      return DateTime(
        datePart.year,
        datePart.month,
        datePart.day,
        timePart.hour,
        timePart.minute,
      );
    } catch (e) {
      print("Error parsing appointment DateTime: $e");
      throw Exception("Invalid date or time format");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonHandler(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationScreen(currentIndex: 0)),
                      );
                    },
                  ),
                  const Center(
                    child: Text(
                      'Animal Corner',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen(currentIndex: 4)),
                      );
                    },
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Schedule an Appointment',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInputCard(),
                const SizedBox(height: 20),
                _buildServiceCard(),
                const SizedBox(height: 30),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNav(currentIndex: widget.currentIndex),
      ),
    );
  }
}

  Widget _buildInputCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              readOnly: true, // Make the TextField read-only
              decoration: InputDecoration(
                labelText: 'Appointment Name',
                icon: const Icon(Icons.assignment),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            // Dropdown for Pet Selection
            DropdownButtonFormField<String>(
              value: selectedPet,
              decoration: InputDecoration(
                labelText: 'Select Pet',
                icon: const Icon(Icons.pets),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              items: userPets
                  .map((pet) => DropdownMenuItem(
                value: pet,
                child: Text(pet),
              ))
                  .toList(),
              onChanged: (newPet) {
                setState(() {
                  selectedPet = newPet;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedService,
              decoration: InputDecoration(
                labelText: 'Select Service',
                icon: const Icon(Icons.medical_services),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              items: services
                  .map((service) => DropdownMenuItem(
                value: service,
                child: Text(service),
              ))
                  .toList(),
              onChanged: (newService) {
                setState(() {
                  selectedService = newService;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Select Day',
                icon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                );

                setState(() {
                  selectedDay = pickedDate.toString().substring(0, 10);
                  _filterTimeSlotsForDay(pickedDate!);
                });
              },
              controller: TextEditingController(text: selectedDay ?? ''),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedTimeSlot,
              decoration: InputDecoration(
                labelText: 'Select Time Slot',
                icon: const Icon(Icons.access_time),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              items: _getFilteredTimeSlots()
                  .map((time) => DropdownMenuItem(
                value: time,
                child: Text(time),
              ))
                  .toList(),
              onChanged: (newTimeSlot) {
                setState(() {
                  selectedTimeSlot = newTimeSlot;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getFilteredTimeSlots() {
    if (selectedDay == null) return []; // No slots if no day is selected

    DateTime now = DateTime.now();
    DateTime selectedDate = DateTime.parse(selectedDay!);
    List<String> slots;

    if (selectedDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      // For today, filter slots that are in the future and before 5 PM
      slots = availableTimeSlots.entries.expand((entry) {
        final period = entry.key;
        return entry.value.map((time) => '$time $period');
      }).where((slot) {
        final slotTime = _parseSlotToDateTimeForToday(slot, selectedDate);
        return slotTime != null && slotTime.isAfter(now) && slotTime.hour < 17;
      }).toList();
    } else {
      // For future dates, allow all slots before 5 PM
      slots = availableTimeSlots.entries.expand((entry) {
        final period = entry.key;
        return entry.value.map((time) => '$time $period');
      }).where((slot) {
        final slotTime = _parseSlotToDateTime(slot);
        return slotTime != null && slotTime.hour < 17;
      }).toList();
    }

    // If no slots are available, show a fallback message
    if (slots.isEmpty) {
      return ['No available slots'];
    }

    return slots;
  }

  DateTime? _parseSlotToDateTimeForToday(String slot, DateTime selectedDate) {
    try {
      final slotTime = DateFormat('h:mm a').parse(slot);
      return DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        slotTime.hour,
        slotTime.minute,
      );
    } catch (e) {
      print("Error parsing slot time for today: $e");
      return null;
    }
  }



  DateTime? _parseSlotToDateTime(String slot) {
    try {
      return DateFormat('h:mm a').parse(slot);
    } catch (e) {
      print("Error parsing slot time: $e");
      return null;
    }
  }

  void _filterTimeSlotsForDay(DateTime pickedDate) {
    setState(() {
      selectedDay = DateFormat('yyyy-MM-dd').format(pickedDate);
      selectedTimeSlot = null; // Reset time slot when the day changes
    });
  }
  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _isSaving || selectedTimeSlot == 'No available slots' ? null : () async {
          if (selectedPet == null || selectedService == null || selectedDay == null || selectedTimeSlot == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill out all fields'),
                backgroundColor: Colors.green,
              ),
            );
            return;
          }

          setState(() {
            _isSaving = true;
          });

          try {
            DateTime appointmentDate = DateFormat('yyyy-MM-dd').parse(selectedDay!);
            DateTime now = DateTime.now();
            String status = appointmentDate.year == now.year && 
                            appointmentDate.month == now.month && 
                            appointmentDate.day == now.day ? 'today' : 'upcoming';

            final appointment = AppointmentModel(
              id: '', // Will be generated by Firestore
              appointmentId: 0, // Will be generated by service
              name: _nameController.text,
              pet: selectedPet!,
              service: selectedService!,
              day: selectedDay!,
              timeSlot: selectedTimeSlot!,
              status: status,
              createdAt: DateTime.now(),
            );

            await _appointmentService.addAppointment(appointment);

            // Show a custom dialog after saving
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  title: const Text(
                    'Appointment Scheduled!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 50,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Your appointment has been successfully scheduled. We look forward to seeing you!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  actions: [
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );

            // Clear inputs after saving
            _nameController.clear();
            setState(() {
              selectedService = null;
              selectedDay = null;
              selectedTimeSlot = null;
              selectedPet = null;
            });
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error saving appointment: $error'),
              ),
            );
          } finally {
            setState(() {
              _isSaving = false;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
        ),
        child: _isSaving
            ? const CircularProgressIndicator()
            : const Text(
          'Save Appointment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: Colors.white, // Ensuring the text color is white
          ),
        ),
      ),
    );
  }

}