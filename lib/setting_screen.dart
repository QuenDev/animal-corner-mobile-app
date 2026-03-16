// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_2/dashboard_screen.dart';
import 'package:flutter_application_2/notif_screen.dart';
import 'package:flutter_application_2/search_screen.dart';
import 'package:flutter_application_2/schedule_screen.dart';
import 'package:flutter_application_2/history_screen.dart';
import 'package:flutter_application_2/pet_profile.dart';
import 'package:flutter_application_2/edit_profile_screen.dart'; 
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_2/change_password_screen.dart';
import 'package:flutter_application_2/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class SettingsScreen extends StatefulWidget {
  final int currentIndex;

  const SettingsScreen({super.key, this.currentIndex = 0});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _currentPage;
  bool _isLoggedOut = false; // Track logout state

  final List<String> clinicPhones = [
    "0955-609-5596",
    "0936-058-3540",
    "0955-337-7258",
    "0908-864-7278"
  ];

  final String clinicLocation = "Muñoz Building, Prenza Street, District 1 National Highway Cauayan City. Near CLACI, Orix Metro and Floor Center, in front of Filipino Home Depot.";

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
     onWillPop: () async {
        // If the user is logged out, prevent going back
        if (_isLoggedOut) {
          return false; // Prevent back navigation
        }
        // Otherwise, navigate to ProfileScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(currentIndex: 4,)),
        );
        return false; // Prevent default back navigation
      },
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
            icon: const Icon(
              Icons.settings,
              color: Colors.yellowAccent,
            ),
            iconSize: 30.0,
            onPressed: () {
              // Navigate to the SettingsScreen as a standalone screen
              Navigator.push(
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
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionTitle('Account Settings'),
            _buildSettingsTile(
              title: 'Edit Profile',
              icon: Icons.person,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen(pet: {})),
                );
              },
            ),
            _buildSettingsTile(
              title: 'Manage Pets',
              icon: Icons.pets,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen(currentIndex: 4)),
                );
              },
            ),
            _buildSettingsTile(
              title: 'Change Password',
              icon: Icons.lock,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                );
              },
            ),
            const Divider(),
            _buildSectionTitle('Legal'),
            _buildSettingsTile(
              title: 'Terms of Service',
              icon: Icons.description,
              onTap: () {
                showTermsOfServiceDialog(context);
              },
            ),
            _buildSettingsTile(
              title: 'Privacy Policy',
              icon: Icons.privacy_tip,
              onTap: () {
                showPrivacyPolicyDialog(context);
              },
            ),
            const Divider(),
            _buildSectionTitle('Clinic Information'),
            _buildSettingsTile(
              title: 'Clinic Locations',
              icon: Icons.location_on,
              onTap: _showLocationDialog,
            ),
            _buildSettingsTile(
              title: 'Contact Us',
              icon: Icons.contact_phone,
              onTap: _showContactDialog,
            ),
           _buildSettingsTile(
  title: 'Facebook',
  icon: Icons.facebook,
  onTap: _launchFacebookPage,
),

            const SizedBox(height: 16), // Add some space before logout button
          ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green, // Background color
    padding: const EdgeInsets.symmetric(vertical: 16.0), // Button height
  ),
  child: const Text(
    'Logout',
    style: TextStyle(
      color: Colors.white, // Font color
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
    ),
  ),
     onPressed: () async {
            // Sign out the user
            await FirebaseAuth.instance.signOut();

            // Set logout state to true
            setState(() {
              _isLoggedOut = true;
            });

            // Navigate to the login screen and remove all previous routes
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()), // Replace with your login screen
              (Route<dynamic> route) => false, // Remove all previous routes
            );
  },
),

          ],
        ),
        bottomNavigationBar: _buildOriginalBottomNavigationBar(),
      ),
    );
  }

  void showPrivacyPolicyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.green,
          ),
        ),
        content: SizedBox(
          width: 300,
          height: 300,
          child: SingleChildScrollView(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 16, fontFamily: 'Montserrat', color: Colors.black),
                children: [
                  TextSpan(text: 'Privacy Policy\nEffective Date:  October 08, 2024\n\n', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '1. ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Information We Collect\n\n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: '1.1 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Personal Information  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'We collect the following personal information when you create an account or interact with the app:\n'),
                  TextSpan(text: '- Name\n- Email address\n- Phone number\n- Address\n- Pet information (name, type, breed, age, gender)\n\n'),
                  TextSpan(text: '1.2 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Usage Data  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'When you use our app, we automatically collect information about how you access and interact with the app, including:\n'),
                  TextSpan(text: '- Device information (device model, OS version, unique device identifier)\n- App usage data (time spent on the app, features used, clicks, etc.)\n- Location information (only if you enable location services)\n\n'),
                  TextSpan(text: '1.3 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Cookies & Tracking Technologies  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'We use cookies and similar technologies to track your activity within the app and improve your experience.\n\n'),
                  TextSpan(text: '2. ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'How We Use Your Information\n\n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: '2.1 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Account Management  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'We use your personal information to manage your account, update your profile, and allow you to schedule appointments.\n\n'),
                  TextSpan(text: '2.2 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Customer Support  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'Your contact information helps us provide support and respond to your inquiries effectively.\n\n'),
                  TextSpan(text: '2.3 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'App Improvements  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'We use your usage data to analyze how the app is performing and make improvements based on user interactions.\n\n'),
                  TextSpan(text: '2.4 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Communication  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'We may use your email or phone number to send you notifications, reminders for appointments, or promotional offers (with your consent).\n\n'),
                  TextSpan(text: '3. ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Sharing Your Information\n\n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: '3.1 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Service Providers  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'We share your data with third-party service providers who assist us in running the app, such as cloud storage and analytics providers.\n\n'),
                  TextSpan(text: '3.2 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Legal Compliance  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'We may share your information if required by law or to protect the rights and safety of our users and the public.\n\n'),
                  TextSpan(text: '3.3 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Business Transfers  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'In the event of a merger, acquisition, or asset sale, your information may be transferred to the new entity.\n\n'),
                  TextSpan(text: '3.4 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Third-Party Login Services  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'If you use third-party login services like Google or Facebook to sign in, we share basic information required for authentication, such as your email address and profile photo.\n\n'),
                  TextSpan(text: '4. ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Data Security\n\n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: '4.1 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Protection Measures  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'We take reasonable steps to secure your data, including encryption, secure servers, and regular security audits. However, no method of data transmission over the Internet is 100% secure.\n\n'),
                  TextSpan(text: '4.2 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Retention Period  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'We retain your information for as long as your account is active or as needed to provide you services. We may retain data for longer periods if required by law.\n\n'),
                  TextSpan(text: '5. ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Your Rights\n\n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: '5.1 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Access & Update  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'You can access and update your personal information at any time by visiting your account settings.\n\n'),
                  TextSpan(text: '5.2 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Data Deletion  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'You can request the deletion of your account and personal data by contacting us. We will process your request within a reasonable timeframe, though certain information may be retained for legal or operational reasons.\n\n'),
                  TextSpan(text: '5.3 ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Opt-Out  \n', style: TextStyle(fontWeight: FontWeight.bold)), // Make this bold
                  TextSpan(text: 'You have the right to opt out of promotional communications by adjusting your settings or clicking on the "unsubscribe" link in any email you receive from us.\n\n'),
                  TextSpan(text: '6. ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Children\'s Privacy\n\n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Our app is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13. If we discover that a child under 13 has provided us with personal information, we will delete it immediately. If you believe we have collected such information, please contact us.\n\n'),
                  TextSpan(text: '7. ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Changes to This Privacy Policy\n\n', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'We may update this Privacy Policy from time to time to reflect changes in our practices or legal obligations. We will notify you of any significant changes by posting the new policy in the app and updating the "Effective Date" at the top of the page.\n\n'),
                  TextSpan(text: '8. ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Contact Us\n\n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'If you have any questions or concerns about this Privacy Policy, please contact us at:-\nPhone: 0955-609-5596\n'),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
 
void showTermsOfServiceDialog(BuildContext context) {
    double fontSize = 16.0; // Control this for regular text size
    double headingFontSize = 20.0; // Control this for headings size

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Terms of Service',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.green,
            ),
          ),
          content: SizedBox(
            width: 300,
            height: 300, // Set the height for the dialog
            child: SingleChildScrollView(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: fontSize, fontFamily: 'Montserrat', color: Colors.black), // Default text style
                  children: [
                    TextSpan(text: 'Last Updated:  October 08, 2024\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                    
                    TextSpan(text: '1. Acceptance of Terms\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: headingFontSize)),
                    const TextSpan(text: 'By accessing or using Animal Corner, you agree to these Terms of Service, which govern your use of our application and any services we offer. If you do not agree to these terms, please do not use the app.\n\n'),

                    TextSpan(text: '2. User Accounts\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: headingFontSize)),
                    const TextSpan(text: 'You are responsible for maintaining the confidentiality of your login information and for all activities that occur under your account. If you suspect any unauthorized use of your account, you must notify us immediately.\n\n'),

                    TextSpan(text: '3. Pet Profiling & Scheduling Services\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: headingFontSize)),
                    const TextSpan(text: 'Our app allows users to create profiles for pets and schedule appointments with service providers. You are responsible for the accuracy of the information you provide and must ensure it is up-to-date.\n\n'),

                    TextSpan(text: '4. Third-Party Integrations\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: headingFontSize)),
                    const TextSpan(text: 'Our app integrates with third-party services, including Google and Facebook, to facilitate login. We do not control these services and are not responsible for their practices. Please review their privacy policies.\n\n'),

                    TextSpan(text: '5. User Conduct\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: headingFontSize)),
                    const TextSpan(text: 'You agree not to use the app for any illegal or unauthorized purposes. This includes, but is not limited to, posting harmful or misleading content, harassment, or spamming other users.\n\n'),

                    TextSpan(text: '6. Data & Privacy\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: headingFontSize)),
                    const TextSpan(text: 'We take your privacy seriously. Please review our Privacy Policy for detailed information on how we collect, use, and protect your personal data.\n\n'),

                    TextSpan(text: '7. Modification of Service\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: headingFontSize)),
                    const TextSpan(text: '[Your Company Name] reserves the right to modify or discontinue the app or any part of it at any time, with or without notice. Your continued use of the app after any modifications constitutes your acceptance of the new terms.\n\n'),

                    TextSpan(text: '8. Termination\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: headingFontSize)),
                    const TextSpan(text: 'We may suspend or terminate your account if you violate these terms or engage in any conduct that we deem harmful to our app or its users.\n\n'),

                    TextSpan(text: '9. Disclaimers\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: headingFontSize)),
                    const TextSpan(text: 'The app is provided on an "as-is" basis. We do not guarantee that the app will always be available, secure, or free from errors.\n\n'),

                    TextSpan(text: '10. Limitation of Liability\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: headingFontSize)),
                    const TextSpan(text: 'Animal Corner will not be liable for any damages arising from your use of the app or any content within it.\n\n'),

                    TextSpan(text: '11. Governing Law\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: headingFontSize)),
                    const TextSpan(text: 'These terms are governed by the laws of Philippines. Any disputes arising from these terms will be handled in accordance with local laws.\n\n'),

                    TextSpan(text: '12. Contact Information\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: headingFontSize)),
                    const TextSpan(text: 'For any questions or concerns regarding these terms, please contact us at: 0955-609-5596\n'),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Contact Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade700),
            ),
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var phone in clinicPhones)
                  GestureDetector(
                  
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            phone,
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Clinic Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade700),
            ),
          ),
          content: const SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Muñoz Building, Prenza Street, District 1 National Highway Cauayan City. Near CLACI, Orix Metro and Floor Center, in front of Filipino Home Depot.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


Widget _buildOriginalBottomNavigationBar() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.green.shade400, Colors.green.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: BottomNavigationBar(
      backgroundColor: Colors.transparent,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 11, fontFamily: 'Montserrat'),
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentPage,
      onTap: (index) {
        // If the same tab is clicked, navigate to the same screen to refresh it
        if (index != _currentPage) {
          setState(() {
            _currentPage = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen(currentIndex: index)),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen(currentIndex: index)),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ScheduleScreen(currentIndex: index)),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen(currentIndex: index)),
              );
              break;
            case 4:
              // Always refresh the ProfileScreen, even if it is the same
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen(currentIndex: 4)),
              );
              break;
          }
        } else {
          // If the same tab is clicked, refresh the current screen
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen(currentIndex: index)),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen(currentIndex: index)),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ScheduleScreen(currentIndex: index)),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen(currentIndex: index)),
              );
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen(currentIndex: 4)),
              );
              break;
          }
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 24),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pets, size: 24), // Updated icon to pets
          label: 'Petcare', // Updated label to Petcare
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
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontFamily: 'Montserrat',
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: onTap,
    );
  }

 void _launchFacebookPage() async {
  const url = 'https://www.facebook.com/people/Animal-Corner-Veterinary-Clinic-Supply/100090203255071/'; // Replace with your Facebook page URL
  if (await canLaunch(url)) {

    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

}
