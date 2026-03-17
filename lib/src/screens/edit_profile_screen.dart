  // ignore_for_file: use_build_context_synchronously

  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart'; // For picking images
  import 'dart:io'; // For File
  import '../models/user_model.dart';
  import '../services/profile_service.dart'; // Ensure this path is correct
  import 'package:flutter_application_2/src/screens/dashboard_screen.dart';
  import 'package:flutter_application_2/src/screens/pet_profile.dart';
  import 'package:flutter_application_2/src/screens/search_screen.dart';
  import 'package:flutter_application_2/src/screens/schedule_screen.dart';
  import 'package:flutter_application_2/src/screens/history_screen.dart';
  import 'package:flutter_application_2/src/screens/notif_screen.dart';
  import 'package:flutter_application_2/src/screens/setting_screen.dart';
  import 'package:flutter_application_2/src/widgets/app_bottom_nav.dart';

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
    final userModel = await ProfileService.loadProfileData();
    if (userModel != null) {
      setState(() {
        _nameController.text = userModel.fullName;
        _phoneController.text = userModel.phone;
        _addressController.text = userModel.address;
        if (userModel.imagePath != null && userModel.imagePath!.isNotEmpty) {
          _imageFile = File(userModel.imagePath!);
        }
      });
    }
  }

  Future<void> _saveProfileData() async {
    final userModel = UserModel(
      uid: '', // ProfileService will handle UID
      fullName: _nameController.text,
      email: '', // ProfileService will preserve email
      phone: _phoneController.text,
      address: _addressController.text,
      imagePath: _imageFile?.path,
    );
    await ProfileService.saveProfileData(userModel);
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

        bottomNavigationBar: AppBottomNav(currentIndex: _currentPage),

  }
