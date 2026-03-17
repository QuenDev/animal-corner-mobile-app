import 'package:flutter/material.dart';
import 'package:flutter_application_2/src/screens/add_pet_screen.dart';
import 'package:flutter_application_2/src/screens/dashboard_screen.dart';
import 'package:flutter_application_2/src/screens/history_screen.dart';
import 'package:flutter_application_2/src/screens/schedule_screen.dart';
import 'package:flutter_application_2/src/screens/search_screen.dart';
import 'dart:io'; // For handling file paths
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:shared_preferences/shared_preferences.dart'; // For shared preferences
import 'edit_profile_screen.dart'; // Update with the correct path
import 'dart:convert'; // For encoding and decoding pet data
import 'package:flutter_application_2/src/screens/notif_screen.dart';
import 'package:flutter_application_2/src/screens/setting_screen.dart';
import 'package:flutter_application_2/src/services/profile_service.dart';
import 'package:flutter_application_2/src/services/pet_service.dart';
import 'package:flutter_application_2/src/models/user_model.dart';
import 'package:flutter_application_2/src/models/pet_model.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter_application_2/src/widgets/back_button.dart';
import 'package:flutter_application_2/src/widgets/app_bottom_nav.dart';
import 'package:flutter_application_2/src/utils/constants.dart';


class ProfileScreen extends StatefulWidget {
  final List<String>? petsList; // Existing parameter
  final int currentIndex; // Add this line

  const ProfileScreen({super.key, this.petsList, required this.currentIndex}); // Update constructor

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late int _currentPage;
  File? _profileImage; // Store the selected profile image
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
   String petId = '';
  final ImagePicker _picker = ImagePicker(); // Define the _picker variable

  // List to hold pet profiles
  List<PetModel> _pets = [];
  final PetService _petService = PetService();

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex; // Initialize _currentPage with currentIndex
    _loadProfileData(); // Load data when the screen is initialized
    _loadPetData(); // 
    

  }
  
  Future<void> _loadProfileData() async {
    final userModel = await ProfileService.loadProfileData();
    if (userModel != null) {
      setState(() {
        _nameController.text = userModel.fullName;
        _phoneController.text = userModel.phone;
        _addressController.text = userModel.address;
        if (userModel.imagePath != null && userModel.imagePath!.isNotEmpty) {
          _profileImage = File(userModel.imagePath!);
        }
      });
    }
  }

  Future<void> saveProfile() async {
    final user = UserModel(
      uid: '', // ProfileService handles UID
      fullName: _nameController.text,
      email: '', // ProfileService preserves email
      phone: _phoneController.text,
      address: _addressController.text,
      imagePath: _profileImage?.path,
    );
    await ProfileService.saveProfileData(user);

    // Refresh the profile data after saving
    await _refreshProfileData(); // Ensure to reload profile data
  }

  Future<void> _refreshProfileData() async {
    await _loadProfileData(); // Reload profile data
  }

  Future<void> _loadPetData() async {
    try {
      final fetchedPets = await _petService.getUserPets();
      setState(() {
        _pets = fetchedPets;
      });
    } catch (e) {
      print("Error loading pets: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _saveProfileImagePath(pickedFile.path); // Save new image path to SharedPreferences
      });
    }
  }

  Future<void> pickPetImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _savePetImagePath(pickedFile.path); // Save new image path to SharedPreferences
      });
    }
  }

  Future<void> _saveProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_image', path);
  }

  Future<void> _savePetImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('pet_image', path);
  }

  Future<void> savePetData(PetModel newPet) async {
    // Note: This logic seems redundant if we are always re-fetching from _loadPetData
    // but keeping it for now if needed. 
    setState(() {
      _pets.add(newPet);
    });
    print('Pet data updated locally');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 10), // Space between the label and owner section
              _buildOwnerSection(),
              const SizedBox(height: 20),
              _buildPetSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: widget.currentIndex),
    ),
    );
  }
}

  Widget _buildOwnerSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Owner',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Navigate to EditProfileScreen and refresh data on return
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(
                            pet: {},
                          ),
                        ),
                      );
                      await _refreshProfileData(); // Ensure to reload profile data
                    },
                    icon: Icon(Icons.edit, size: 16, color: Colors.green.shade400),
                    label: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade400,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      side: BorderSide(color: Colors.green.shade400),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                radius: 50.0,
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.person, size: 70, color: Colors.green)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildCustomLabelField("Name", _nameController), // Updated label-field design
          const SizedBox(height: 20),
          _buildCustomLabelField("Phone Number", _phoneController), // Updated label-field design
          const SizedBox(height: 20),
          _buildCustomLabelField("Address", _addressController), // Updated label-field design
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCustomLabelField(String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14.0, // Adjusted font size
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        const SizedBox(width: 8), // Space between label and text field
        Expanded(
          flex: 2,
          child: TextField(
            controller: controller,
            readOnly: true,
            maxLines: null, // Allows dynamic height
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white, // Fixed white background
              border: OutlineInputBorder(), // Keep the border
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green), // Border color when focused
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green), // Border color when enabled
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0), // Padding
            ),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.normal,
              fontSize: 14.0, // Adjusted font size
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.green.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Pets',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddPetScreen(),
                      ),
                    );
                    if (result != null) {
                      _loadPetData(); // Reload pet data after adding a new pet
                    }
                  },
                  icon: Icon(Icons.add, size: 16, color: Colors.green.shade400),
                  label: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade400,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(color: Colors.green.shade400),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        // Pass index when building pet cards
        ..._pets.asMap().entries.map((entry) {
          int index = entry.key;
          PetModel petData = entry.value;
          return _buildPetCard(petData, index);
        }),
      ],
    );
  }



 Widget _buildPetCard(PetModel petData, int index) {
  String petName = petData.name;
  String petType = petData.type;
  String petBreed = petData.breed;
  String petAge = petData.age;
  String petGender = petData.gender;
  String petColor = petData.color; // New field
  String petWeight = petData.weight; // New field
  String? petImagePath = petData.imagePath;
  File? petImage = petImagePath != null && petImagePath.isNotEmpty ? File(petImagePath) : null;

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 4,
    child: Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.greenAccent,
            radius: 30.0,
            backgroundImage: petImage != null ? FileImage(petImage) : null,
            child: petImage == null
                ? const Icon(Icons.pets, color: Colors.green, size: 40)
                : null,
          ),
          title: Text(
            petName,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type: $petType'),
              Text('Breed: $petBreed'),
              Text('Age: $petAge'),
              Text('Gender: $petGender'),
              Text('Color: $petColor'), // Display Color
              Text('Weight: $petWeight'), // Display Weight
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: Colors.green),
            onPressed: () async {
              // Navigate to AddPetScreen for editing, passing the pet data
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPetScreen(
                    petData: petData, // Pass the current pet's data
                    isEdit: true, // Indicate that it's an edit operation
                    petIndex: index, // Pass the index for updating the right pet
                    petId: petData.id, // Pass the petId for updating
                  ),
                ),
              );
              if (result != null) {
                _loadPetData(); // Reload pet data after editing
              }
            },
          ),
        ),
      ],
    ),
  );
}


}