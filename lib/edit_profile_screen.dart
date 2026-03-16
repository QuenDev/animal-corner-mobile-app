  // ignore_for_file: use_build_context_synchronously

  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart'; // For picking images
  import 'dart:io'; // For File
  import '../profile_service.dart'; // Ensure this path is correct
  import 'package:flutter_application_2/dashboard_screen.dart';
  import 'package:flutter_application_2/pet_profile.dart';
  import 'package:flutter_application_2/search_screen.dart';
  import 'package:flutter_application_2/schedule_screen.dart';
  import 'package:flutter_application_2/history_screen.dart';
  import 'package:flutter_application_2/notif_screen.dart';
  import 'package:flutter_application_2/setting_screen.dart';

  class EditProfileScreen extends StatefulWidget {
    const EditProfileScreen({super.key, required Map pet});

    @override
    _EditProfileScreenState createState() => _EditProfileScreenState();
  }

  class _EditProfileScreenState extends State<EditProfileScreen> {
    int _currentPage = 4; // To match the profile page tab

    File? _imageFile;
    final ImagePicker _picker = ImagePicker();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _addressController = TextEditingController();

     @override
  void initState() {
    super.initState();
    _loadProfileData();
    
  }

  // Load profile data from SharedPreferences
  Future<void> _loadProfileData() async {
    final data = await ProfileService.loadProfileData();
    setState(() {
      _nameController.text = data['owner_name']!;
      _phoneController.text = data['owner_phone']!;
      _addressController.text = data['owner_address']!;
      String? imagePath = data['profile_image'];
      if (imagePath != null && imagePath.isNotEmpty) {
        _imageFile = File(imagePath);
      }
    });
  }

  Future<void> _saveProfileData() async {
  {
    // Save profile data locally and to Firestore
    await ProfileService.saveProfileData(
      _nameController.text,
      _phoneController.text,
      _addressController.text,
      _imageFile?.path, // File path of the profile image
    );
  }
  }
  
  // Function to pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Assign selected image to _imageFile
      });
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
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
                // Header section for "Edit Profile" and "Owner"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade400, Colors.green.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Owner',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Circle Avatar for profile picture with image picker
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50, // Profile picture size
                        backgroundImage: _imageFile != null 
                            ? FileImage(_imageFile!) as ImageProvider
                            : const AssetImage('assets/profile_image.png'), // Default image
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            _pickImage(ImageSource.gallery); // Open image picker
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Change Profile Photo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Added extra space between avatar and form

                // Name Section
                const Text(
                  'Owner Name', // Label above text box
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Reduced padding for smaller box
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8), // Smaller border radius
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade700),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Reduced spacing between text boxes

                // Phone Number Section
                const Text(
                  'Phone Number', // Label above text box
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Reduced padding
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade700),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                // Address Section
                const Text(
                  'Address', // Label above text box
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Reduced padding
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade700),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 30), // More space before save button

                // Save Button
               // Save Button
// Save Button
Center(
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        // Save profile data to SharedPreferences and Firestore
        await _saveProfileData();

        // After saving, navigate to ProfileScreen and remove previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(
              currentIndex: 4, // Pass currentIndex value to ProfileScreen
            ),
          ),
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700, // Button color
        padding: const EdgeInsets.symmetric(vertical: 12), // Button padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded button
        ),
      ),
      child: const Text(
        'SAVE',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
          color: Colors.white,
        ),
      ),
    ),
  ),
)


              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildCustomBottomNavigationBar(),
      );
    }

   Widget _buildCustomBottomNavigationBar() {
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
      unselectedLabelStyle: const TextStyle(
        fontSize: 11,
        fontFamily: 'Montserrat',
      ),
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentPage,
      onTap: (index) {
  if (index != _currentPage) {
    setState(() {
      _currentPage = index;
    });

    Widget screen;
    switch (index) {
      case 0:
        screen = DashboardScreen(currentIndex: index);
        break;
      case 1:
        screen = const SearchScreen(currentIndex: 1);
        break;
      case 2:
        screen = const ScheduleScreen(currentIndex: 2);
        break;
      case 3:
        screen = const HistoryScreen(currentIndex: 3);
        break;
      case 4:
      default:
        screen = const ProfileScreen(currentIndex: 4);
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }
},

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
