import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_application_2/src/screens/pet_profile.dart';
import 'package:flutter_application_2/src/screens/search_screen.dart';
import 'package:flutter_application_2/src/screens/schedule_screen.dart';
import 'package:flutter_application_2/src/screens/history_screen.dart';
import 'package:flutter_application_2/src/screens/notif_screen.dart';
import 'package:flutter_application_2/src/screens/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_2/src/widgets/app_bottom_nav.dart';
import 'package:flutter_application_2/src/widgets/back_button.dart';
import 'package:flutter_application_2/src/services/appointment_service.dart';
import 'package:flutter_application_2/src/services/profile_service.dart';
import 'package:flutter_application_2/src/models/appointment_model.dart';
import 'package:flutter_application_2/src/models/user_model.dart';


class DashboardScreen extends StatefulWidget {
  final int currentIndex; // Add the currentIndex to be passed
  final List<String>? upcomingAppointments;

  const DashboardScreen({super.key, required this.currentIndex, this.upcomingAppointments});

  @override 
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  List<AppointmentModel> _upcomingAppointments = [];
  String _userName = 'Fur Parent';
  final AppointmentService _appointmentService = AppointmentService();

  Future<void> _loadData() async {
    try {
      // Load user profile for greeting
      UserModel? user = await ProfileService.loadProfileData();
      if (user != null && user.fullName.isNotEmpty) {
        setState(() {
          _userName = user.fullName;
        });
      }

      // Load upcoming appointments
      List<AppointmentModel> appointments = await _appointmentService.getAppointmentsByStatus('upcoming');
      
      // Filter for future appointments only if needed (Service might already do this, 
      // but let's be safe for current day appointments)
      final currentTime = DateTime.now();
      setState(() {
        _upcomingAppointments = appointments.where((app) {
          try {
            final DateTime appointmentDateTime = DateFormat('yyyy-MM-dd h:mm a')
                .parse('${app.day} ${app.timeSlot}');
            return appointmentDateTime.isAfter(currentTime);
          } catch (e) {
            return true; // If parsing fails, keep it for now
          }
        }).toList();
      });
    } catch (e) {
      print("Error loading data for dashboard: $e");
    }
  }



  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController = PageController(initialPage: _currentPage);
    _startAutoPlay();
    _loadData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < 8) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
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
                borderRadius: BorderRadius.zero,
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
                _buildGreetingMessage(),
                const SizedBox(height: 20),
                _buildUpcomingAppointments(),
                const SizedBox(height: 24),
                _buildAvailableServices(),
                const SizedBox(height: 24),
                _buildPetCareNews(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNav(currentIndex: widget.currentIndex),
      ),
    );
  }

Widget _buildGreetingMessage() {
  final hour = DateTime.now().hour;
  String greeting;

  if (hour < 12) {
    greeting = 'Good Morning, $_userName!';
  } else if (hour < 18) {
    greeting = 'Good Afternoon, $_userName!';
  } else {
    greeting = 'Good Evening, $_userName!';
  }

  return Row(
    children: [
      const Icon(
        Icons.pets,
        color: Colors.green,
        size: 28.0,
      ),
      const SizedBox(width: 8.0),
      Text(
        greeting,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    ],
  );
}

Widget _buildUpcomingAppointments() {
  List<AppointmentModel> sortedAppointments = List.from(_upcomingAppointments);
  sortedAppointments.sort((a, b) {
    return a.day.compareTo(b.day);
  });

  final limitedAppointments = sortedAppointments.take(2).toList();

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.green.shade50, Colors.green.shade100],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(color: Colors.green.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8.0,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Upcoming Appointments',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        limitedAppointments.isEmpty
            ? const Center(
                child: Text(
                  'No upcoming appointments.',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black45,
                  ),
                ),
              )
            : Column(
                children: limitedAppointments.map((appointment) {
                  final petName = appointment.pet;
                  final service = appointment.service;
                  final date = appointment.day;
                  final time = appointment.timeSlot;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.green.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.event, color: Colors.green.shade400, size: 24.0),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$service for $petName',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$date at $time',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ],
    ),
  );
}


Widget _buildAvailableServices() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Services',
          style: TextStyle(
           fontSize: 19.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Montserrat',
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildServiceTile('Consultations', Icons.chat),
              _buildServiceTile('Emergency Cases', Icons.local_hospital),
              _buildServiceTile('Grooming', Icons.local_car_wash),
              _buildServiceTile('Vaccinations', Icons.vaccines),
              _buildServiceTile('Surgery', Icons.medical_services),
              _buildServiceTile('Dog & Cat Hotel', Icons.hotel),
_buildServiceTile('Deworming', Icons.health_and_safety), // New service
              _buildServiceTile('Confinement', Icons.access_alarm), // New service
              _buildServiceTile('Pet Pharmacy', Icons.local_pharmacy), // New service
              _buildServiceTile('Stud Services', Icons.pets), // New service
            ].expand((widget) => [widget, const SizedBox(width: 12)]).toList(), // Adjusted spacing to 12
          ),
        ),
      ],
    ),
  );
}


Widget _buildServiceTile(String name, IconData icon) {
  return GestureDetector(
    onTap: () {},
    child: SizedBox(
      width: 95, // Fixed width for consistent layout
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Align text and icon to the center
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0), // Icon container padding
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 83, 205, 91), Colors.green.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32.0, // Icon size
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            name,
            textAlign: TextAlign.center, // Align text to the center
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            maxLines: 2, // Allow a maximum of 2 lines for text
            overflow: TextOverflow.ellipsis, // Add ellipsis if the text is too long
          ),
        ],
      ),
    ),
  );
}


Widget _buildPetCareNews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pet Care Advice & Tips',
          style: TextStyle(
            fontSize: 19.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Montserrat',
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 230,
          child: PageView(
            controller: _pageController,
            children: [
              _buildPetCareItem(
                'Daily Exercise for Your Dog',
                'Dogs require at least 30 to 60 minutes of physical activity each day to stay healthy. Regular morning or evening walks, playing fetch, or using interactive toys can keep them engaged and reduce anxiety.',
                Icons.directions_run,
              ),
              _buildPetCareItem(
                'Healthy Diet for Cats',
                'Cats thrive on a balanced, high-protein diet. Avoid feeding them harmful human foods like chocolate, onions, and dairy products. Maintaining a consistent feeding schedule is also essential.',
                Icons.pets,
              ),
              _buildPetCareItem(
                'Importance of Hydration',
                'Ensure your pets have access to clean, fresh water at all times. Using a pet water fountain can encourage them to drink more, especially during hot weather or after physical activities.',
                Icons.water_drop,
              ),
              _buildPetCareItem(
                'Vaccinations and Vet Visits',
                'Regular vet visits and keeping vaccinations up-to-date are vital for your pet’s health. Preventative care and early detection of potential health issues can help your pet live a longer and happier life.',
                Icons.local_hospital,
              ),
              _buildPetCareItem(
                'Dental Health for Pets',
                'Regularly brushing your pet’s teeth or providing dental treats can prevent tooth decay and gum disease. Schedule yearly dental check-ups with your vet to maintain their oral health.',
                Icons.medical_services,
              ),
              _buildPetCareItem(
                'Grooming Tips',
                'Regular grooming prevents matted fur, skin infections, and other issues. Choose the right brush for your pet’s coat type, keep their nails trimmed, and ensure their ears are clean.',
                Icons.brush,
              ),
              _buildPetCareItem(
                'Training and Socialization',
                'Start training early to instill good habits. Use positive reinforcement methods and socialize your pets with other animals and people to build confidence and reduce anxiety.',
                Icons.school,
              ),
              _buildPetCareItem(
                'Parasite Prevention',
                'Regularly use flea, tick, and worm prevention to protect your pet from parasites. Check your pet for parasites after walks and keep their living environment clean.',
                Icons.bug_report,
              ),
              _buildPetCareItem(
                'Handling Separation Anxiety',
                'Help your pet get used to being alone by gradually increasing the duration of separation. Provide toys and activities to keep them engaged and use calming sprays if necessary.',
                Icons.alarm,
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildPetCareItem(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.green.shade800, size: 30.0),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16.0, // Adjusted font size for readability
                        color: Colors.black87,
                        fontFamily: 'Georgia', // Changed font style for readability
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}