import 'package:flutter/material.dart';
import 'package:flutter_application_2/src/screens/edit_profile_screen.dart'; 
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_2/src/screens/change_password_screen.dart';
import 'package:flutter_application_2/src/screens/login_screen.dart';
import 'package:flutter_application_2/src/screens/pet_profile.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter_application_2/src/widgets/app_bottom_nav.dart';
import 'package:flutter_application_2/src/widgets/legal_dialogs.dart';
import 'package:flutter_application_2/src/utils/constants.dart';
import 'package:flutter_application_2/src/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  final int currentIndex;

  const SettingsScreen({super.key, this.currentIndex = 4});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoggedOut = false;

  final List<String> clinicPhones = [
    "0955-609-5596",
    "0936-058-3540",
    "0955-337-7258",
    "0908-864-7278"
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isLoggedOut) return false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen(currentIndex: 4)),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Settings', style: AppStyles.heading2),
          backgroundColor: AppColors.primaryGreen,
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionTitle('Account Settings'),
            _buildSettingsTile(
              title: 'Edit Profile',
              icon: Icons.person,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen(pet: {}))),
            ),
            _buildSettingsTile(
              title: 'Change Password',
              icon: Icons.lock,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen())),
            ),
            const Divider(),
            _buildSectionTitle('Legal'),
            _buildSettingsTile(
              title: 'Terms of Service',
              icon: Icons.description,
              onTap: () => LegalDialogs.showTermsOfService(context),
            ),
            _buildSettingsTile(
              title: 'Privacy Policy',
              icon: Icons.privacy_tip,
              onTap: () => LegalDialogs.showPrivacyPolicy(context),
            ),
            const Divider(),
            _buildSectionTitle('Clinic Information'),
            _buildSettingsTile(
              title: 'Contact Us',
              icon: Icons.contact_phone,
              onTap: _showContactDialog,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              onPressed: () async {
                await AuthService().signOut();
                setState(() => _isLoggedOut = true);
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        bottomNavigationBar: AppBottomNav(currentIndex: widget.currentIndex),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(title, style: AppStyles.heading2.copyWith(color: AppColors.primaryGreen)),
    );
  }

  Widget _buildSettingsTile({required String title, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title, style: AppStyles.bodyText),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.primaryGreen),
      onTap: onTap,
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Us', style: AppStyles.heading2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: clinicPhones.map((phone) => ListTile(
            leading: const Icon(Icons.phone, color: AppColors.primaryGreen),
            title: Text(phone),
          )).toList(),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }
}

}
