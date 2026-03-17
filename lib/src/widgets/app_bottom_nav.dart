import 'package:flutter/material.dart';
import 'package:flutter_application_2/src/screens/dashboard_screen.dart';
import 'package:flutter_application_2/src/screens/search_screen.dart';
import 'package:flutter_application_2/src/screens/schedule_screen.dart';
import 'package:flutter_application_2/src/screens/history_screen.dart';
import 'package:flutter_application_2/src/screens/pet_profile.dart'; // This is ProfileScreen
import 'package:flutter_application_2/src/utils/constants.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex && index != 4) return; // Don't reload if same tab, except profile

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = DashboardScreen(currentIndex: index);
        break;
      case 1:
        nextScreen = SearchScreen(currentIndex: index);
        break;
      case 2:
        nextScreen = ScheduleScreen(currentIndex: index);
        break;
      case 3:
        nextScreen = HistoryScreen(currentIndex: index);
        break;
      case 4:
        nextScreen = const ProfileScreen(currentIndex: 4);
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen.withOpacity(0.8), AppColors.primaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: AppStyles.bodyText.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        unselectedLabelStyle: AppStyles.bodyText.copyWith(
          fontSize: 11,
          color: Colors.white70,
        ),
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets, size: 24),
            label: 'Petcare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: 24),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 24),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
