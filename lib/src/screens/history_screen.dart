import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/src/screens/pet_profile.dart';
import 'package:flutter_application_2/src/screens/schedule_screen.dart';
import 'package:flutter_application_2/src/screens/search_screen.dart';
import 'package:flutter_application_2/src/screens/dashboard_screen.dart';
import 'package:flutter_application_2/src/screens/notif_screen.dart';
import 'package:flutter_application_2/src/screens/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import to use DateFormat
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_2/src/widgets/back_button.dart';
import 'package:flutter_application_2/src/widgets/app_bottom_nav.dart';
import 'package:flutter_application_2/src/utils/constants.dart';
import 'package:flutter_application_2/src/services/appointment_service.dart';
import 'package:flutter_application_2/src/models/appointment_model.dart';

class HistoryScreen extends StatefulWidget {
  final int currentIndex;

  const HistoryScreen({super.key, required this.currentIndex});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late int _currentPage;
  bool _isLoading = true;
  List<AppointmentModel> appointments = [];
  Map<String, int> serviceCount = {};
  String errorMessage = '';
  final AppointmentService _appointmentService = AppointmentService();
  bool isHistoryCleared = false;
  String selectedStatus = 'completed'; // Default to 'completed'
  Map<String, Color> statusColorMap = { 
   'today': Colors.orange, 
  'upcoming': Colors.blue,
  'missed': Colors.red,
  'completed': Colors.green.shade700,
};

  // ScrollController to maintain scroll position
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex;
     _loadHistoryClearedState(); // Load the cleared state from local storage
    if (!isHistoryCleared) {
      _fetchAppointments(); // Fetch appointments on init
    }
  }
  
Future<void> _loadHistoryClearedState() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    isHistoryCleared = prefs.getBool('historyCleared') ?? false;

    // Load cleared states for the specific status
    bool isMissedCleared = prefs.getBool('historyClearedMissed') ?? false;
    bool isCompletedCleared = prefs.getBool('historyClearedCompleted') ?? false;

    if (selectedStatus == 'missed' && isMissedCleared) {
      appointments = [];
      serviceCount.clear();
    } else if (selectedStatus == 'completed' && isCompletedCleared) {
      appointments = [];
      serviceCount.clear();
    }
  });
}

Future<void> _fetchAppointments() async {
  setState(() {
    _isLoading = true;
    errorMessage = '';
  });

  try {
    // Check if the status has been cleared, and skip fetching cleared appointments
    final prefs = await SharedPreferences.getInstance();
    bool isMissedCleared = prefs.getBool('historyClearedMissed') ?? false;
    bool isCompletedCleared = prefs.getBool('historyClearedCompleted') ?? false;

    if ((selectedStatus == 'missed' && isMissedCleared) || (selectedStatus == 'completed' && isCompletedCleared)) {
      setState(() {
        appointments = [];
        errorMessage = 'No appointments found for the selected status.';
      });
      return;
    }

    // Proceed with fetching the appointments for the selected status
    List<AppointmentModel> fetchedAppointments = await _appointmentService.getAppointmentsByStatus(selectedStatus);

    if (fetchedAppointments.isNotEmpty) {
      // Update status to 'today' if the appointment's day is today
      DateTime today = DateTime.now();
      for (var appointment in fetchedAppointments) {
        if (appointment.status == 'upcoming') {
          DateTime appointmentDate = DateTime.parse(appointment.day);
          if (appointmentDate.year == today.year && appointmentDate.month == today.month && appointmentDate.day == today.day) {
            await _appointmentService.updateAppointmentStatus(appointment.id, 'today');
            // Note: Since we are updating Firestore, it might be better to re-fetch or update locally
            appointment.status = 'today'; 
          }
        }
      }

      setState(() {
        appointments = fetchedAppointments;
        errorMessage = '';
      });

      if (selectedStatus == 'completed') {
        _calculateServiceCounts();
      }
    } else {
      setState(() {
        appointments = [];
        errorMessage = 'No appointments found for the selected status.';
      });
    }
  } catch (error) {
    setState(() {
      errorMessage = 'Failed to load appointments. Error: $error';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  void _calculateServiceCounts() {
    serviceCount.clear();

    for (var appointment in appointments) {
      String service = appointment.service;
      serviceCount[service] = (serviceCount[service] ?? 0) + 1;
    }
  }

  void clearHistory(String status) async {
  final prefs = await SharedPreferences.getInstance();
  
  setState(() {
    // Clear only the appointments for the selected status from the UI
    appointments = appointments.where((appointment) => appointment.status != status).toList();
    serviceCount.clear();
    errorMessage = appointments.isEmpty ? 'No appointments found.' : '';
  });

  // Store the cleared history state for this particular status
  if (status == 'missed') {
    prefs.setBool('historyClearedMissed', true);
  } else if (status == 'completed') {
    prefs.setBool('historyClearedCompleted', true);
  }

  // Save the overall history cleared state
  prefs.setBool('historyCleared', true);
  
  // Prevent the cleared appointments from being fetched again
  await _fetchAppointments(); // Re-fetch to make sure new appointments are shown
}



  @override
  Widget build(BuildContext context) {
     return BackButtonHandler(
    child:  Scaffold(
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
             controller: _scrollController,// Attach the ScrollController
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryFilter(), // Category filter
                  const SizedBox(height: 20),
                  _buildAppointmentHistory(),
                  const SizedBox(height: 20),
                  if (selectedStatus == 'completed') _buildServiceSummary(),
                ],
              ),
            ),
      bottomNavigationBar: AppBottomNav(currentIndex: widget.currentIndex),
    )
    );
  }
}

Widget _buildAppointmentHistory() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Appointment History',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            // Only show the 'Clear History' button for 'missed' or 'completed'
            if (selectedStatus == 'missed' || selectedStatus == 'completed')
              TextButton(
                onPressed: () => clearHistory(selectedStatus),
                child: const Text(
                  'Clear History',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (appointments.isEmpty)
          Center(
            child: Text(
              errorMessage.isEmpty ? "No appointments found." : errorMessage,
              style: const TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 14.0,
              ),
            ),
          ),
        ...appointments.map((appointment) {
          String petName = appointment.pet;
          String service = appointment.service;
          String day = appointment.day;
          String timeSlot = appointment.timeSlot;
          String status = appointment.status;

          String formattedDay = _formatDay(day);
          String formattedTime = _formatTime(timeSlot);

          // Get colors based on status
          Color statusColor = statusColorMap[status.toLowerCase()] ?? Colors.white;
          Color statusBackground = statusColor.withOpacity(0.2);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        petName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: statusBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          status == 'today' ? 'Today' : status,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$service - $formattedDay at $formattedTime',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    ),
  );
}



// Helper function to format the day
String _formatDay(String day) {
  try {
    final DateTime date = DateTime.parse(day);
    final DateFormat formatter = DateFormat('MMMM dd, yyyy'); // Example: "October 31, 2024"
    return formatter.format(date);
  } catch (e) {
    return day; // Return the original input if parsing fails
  }
}

// Helper function to format the time slot
String _formatTime(String timeSlot) {
  // Assuming timeSlot is like '10:00 AM Morning'
  List<String> parts = timeSlot.split(' ');
  if (parts.length >= 2) {
    return '${parts[0]} ${parts[1]}'; // "10:00 AM"
  }
  return timeSlot;
}


 Widget _buildServiceSummary() {
  if (selectedStatus != 'completed') {
    return const SizedBox.shrink(); // Hide if status is not 'completed'
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6.0,
            spreadRadius: 2.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Service Summary',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.blueGrey.shade700,
                  size: 24.0,
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 1, color: Colors.grey),
          // Service List
          if (serviceCount.isNotEmpty)
            ...serviceCount.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green.shade600,
                          size: 18.0,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    // Number counter without background color
                    Text(
                      "${entry.value} times",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          if (serviceCount.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "No services recorded yet.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}



Widget _buildCategoryFilter() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6.0,
            spreadRadius: 2.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildCategoryButton(
              'Today',
              Icons.calendar_today,
              Colors.orange,
              selectedStatus == 'today',
            ),
            const SizedBox(width: 8.0),
            _buildCategoryButton(
              'Upcoming',
              Icons.today,
              Colors.blue,
              selectedStatus == 'upcoming',
            ),
            const SizedBox(width: 8.0),
            _buildCategoryButton(
              'Missed',
              Icons.cancel,
              Colors.red,
              selectedStatus == 'missed',
            ),
            const SizedBox(width: 8.0),
            _buildCategoryButton(
              'Completed',
              Icons.check_circle,
              Colors.green.shade700,
              selectedStatus == 'completed',
            ),
          ],
        ),
      ),
    ),
  );
}


Widget _buildCategoryButton(String label, IconData icon, Color color, bool isSelected) {
  return GestureDetector(
    onTap: () {
      setState(() {
        // Save the current scroll position before fetching appointments
        double currentPosition = _scrollController.position.pixels;
        selectedStatus = label.toLowerCase(); // Update selected status
        _fetchAppointments().then((_) {
          // After fetching, restore the scroll position
          _scrollController.jumpTo(currentPosition);
        });
      });
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isSelected ? color : Colors.grey.shade300,
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18.0),
          const SizedBox(width: 8.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: isSelected ? color : Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}

}
