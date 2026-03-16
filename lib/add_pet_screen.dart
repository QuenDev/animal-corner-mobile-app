import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../dashboard_screen.dart';
import '../pet_profile.dart';
import 'package:flutter_application_2/notif_screen.dart';
import 'package:flutter_application_2/setting_screen.dart';
import 'package:flutter_application_2/search_screen.dart';
import 'package:flutter_application_2/schedule_screen.dart';
import 'package:flutter_application_2/history_screen.dart';
import '../pet_service.dart';
import 'package:flutter/services.dart';


class AddPetScreen extends StatefulWidget {
  final Map<String, dynamic>? petData;
  final bool isEdit;
  final int? petIndex;
  final String? petId;

  const AddPetScreen({super.key, this.petData, this.isEdit = false, this.petIndex, this.petId});

  @override

  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _customTypeController = TextEditingController();
  final TextEditingController _customBreedController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _petImage;

  // Dropdown values
  String _petType = 'Cat';
  String _breed = 'Siamese';
  String _gender = 'Male';
  String _ageUnit = 'Month/s';

  final List<String> _ageUnits = ['Month/s', 'Year/s'];

  // Updated breed lists
  final List<String> _catBreeds = [
    'Puspin',
    'Persian',
    'Siamese',
    'British Shorthair',
    'Bengal',
    'Himalayan',
    'Sphynx'
  ];
  final List<String> _dogBreeds = [
    'Aspin',
    'Shih Tzu',
    'Chihuahua',
    'Labrador Retriever',
    'Beagle',
    'Golden Retriever',
    'Poodle',
    'Siberian Husky',
    'Dachshund',
    'Rottweiler',
    'American Bully',
    'Bulldog'

  ];
  final List<String> _petTypes = ['Cat', 'Dog', 'Other'];

  final List<String> _genders = ['Male', 'Female'];

  int _currentIndex = 4; // Current index for the bottom navigation

  @override
  void dispose() {
    _customTypeController.dispose();
    _customBreedController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.petData != null) {
      _nameController.text = widget.petData!['name'] ?? '';
      _petType = widget.petData!['type'] ?? 'Cat';
      // Handle custom type
      if (!_petTypes.contains(_petType)) {
        _customTypeController.text = _petType;
        _petType = 'Other'; // Set dropdown to "Other"
      }
      _breed = widget.petData!['breed'] ?? '';
      // Handle custom breed
      if ((_petType == 'Cat' && !_catBreeds.contains(_breed)) ||
          (_petType == 'Dog' && !_dogBreeds.contains(_breed)) ||
          _petType == 'Other') {
        _customBreedController.text = _breed;
        _breed = 'Other'; // Set dropdown to "Other"
      }
      // Extract age details
      final ageDetails = widget.petData!['age']?.split(' ');
      if (ageDetails != null && ageDetails.length == 2) {
        _ageController.text = ageDetails[0]; // Extract the number part
        _ageUnit = ageDetails[1];           // Extract the unit part
      }
      _gender = widget.petData!['gender'] ?? 'Female';
      _colorController.text = widget.petData!['color'] ?? '';
      _weightController.text = widget.petData!['weight'] ?? '';
      if (widget.petData!['imagePath'] != null) {
        _petImage = File(widget.petData!['imagePath']);
      }
    }
  }


  Future<void> _savePetDetails() async {
    // Ensure no field is left empty
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _colorController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Exit the function if fields are empty
    }

    // Validate age
    if (double.tryParse(_ageController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid number for age.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> pets = [];
    String? petsData = prefs.getString('pets');

    if (petsData != null && petsData.isNotEmpty) {
      try {
        pets = List<Map<String, dynamic>>.from(json.decode(petsData));
      } catch (e) {
        print('Error parsing pets data: $e');
        pets = [];
      }
    } else {
      pets = [];
    }
    // Construct pet details map
    Map<String, dynamic> petDetails = {
      'name': _nameController.text,
      'breed': _breed == 'Other' ? _customBreedController.text : _breed,
      'type': _petType == 'Other' ? _customTypeController.text : _petType,
      'age': '${_ageController.text} $_ageUnit',
      'gender': _gender,
      'color': _colorController.text,
      'weight': _weightController.text,
      'imagePath': _petImage?.path,
    };

// Debugging Information
    print('Pets list length: ${pets.length}');
    print('Pets list content: $pets');
    print('Pet index: ${widget.petIndex}');

    try {
      // Update pet locally
      if (widget.isEdit) {
        if (pets.isEmpty) {
          throw Exception('No pets available to edit.');
        }

        if (widget.petIndex == null || widget.petIndex! < 0 || widget.petIndex! >= pets.length) {
          throw Exception(
            'Invalid pet index for editing: petIndex=${widget.petIndex}, petsLength=${pets.length}',
          );
        }

        pets[widget.petIndex!] = petDetails;
      } else {
        pets.add(petDetails);
      }
      // Save to SharedPreferences
      prefs.setString('pets', json.encode(pets));

      // Save to Firebase
      if (widget.isEdit && widget.petId != null) {
        await PetService().updatePetToFirebase(widget.petId!, petDetails);
      } else if (!widget.isEdit) {
        await PetService().savePetToFirebase(petDetails);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isEdit
              ? 'Pet profile updated successfully!'
              : 'Pet profile added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back after a slight delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context, pets);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  Future<void> _pickPetImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _petImage = File(pickedFile.path);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEdit ? 'Edit Pet Profile' : 'Add Pet Profile',
                    style: const TextStyle(
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
                      'Pet',
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
              Center(
                child: GestureDetector(
                  onTap: _pickPetImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _petImage != null
                        ? FileImage(_petImage!)
                        : const AssetImage('assets/images/pet_placeholder.png') as ImageProvider,
                    child: Align(
                      alignment: Alignment.bottomRight,
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
                ),
              ),
              const SizedBox(height: 16),
              _buildInputRow('Name', _nameController),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownRow(
                    'Type',
                    _petType,
                    _petTypes,
                        (value) {
                      setState(() {

                        _petType = value!;
                        _breed = ''; // Reset breed when pet type changes
                      });
                    },
                  ),
                  if (_petType == 'Other')
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child:_buildInputRow('Specify Type', _customTypeController),

                    ),
                ],
              ),

              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownRow(
                    'Breed',
                    _breed,
                    _petType == 'Cat'
                        ? [..._catBreeds, 'Other'] // Add "Other" to cat breeds
                        : _petType == 'Dog'
                        ? [..._dogBreeds, 'Other'] // Add "Other" to dog breeds
                        : ['Other'], // Only "Other" if type is not Cat or Dog
                        (value) {
                      setState(() {
                        _breed = value!;
                      });
                    },
                  ),
                  if (_breed == 'Other')
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: _buildInputRow('Specify Breed', _customBreedController),
                    ),
                ],
              ),


              const SizedBox(height: 16),
              _buildAgeInputRow(),
              const SizedBox(height: 16),
              _buildDropdownRow(
                'Gender',
                _gender,
                _genders,
                    (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildInputRow('Color', _colorController), // New input field
              const SizedBox(height: 16),
              _buildInputRow('Weight', _weightController), // New input field
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _savePetDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Update current index
            });

            // Navigate to the corresponding screen based on the selected index
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen(currentIndex: 0,)),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen(currentIndex: 1,)),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScheduleScreen(currentIndex: 2,)),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen(currentIndex: 3,)),
              );
            } else if (index == 4) { // Index for Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen(currentIndex: 4)),
              );
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
      ),

    );
  }

  _buildInputRow(String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label == 'Weight' ? 'Enter weight (kg/lb)' : null, // Set hint for weight
              hintStyle: TextStyle(
                color: Colors.grey.shade600, // Adjust opacity (lower than default)
                fontSize: 14,
              ),
              border: const OutlineInputBorder(),
            ),
            keyboardType: label == 'Age' ? TextInputType.number : TextInputType.text,
          ),
        ),
      ],
    );
  }

  Widget _buildAgeInputRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 100,
          child: Text(
            'Age',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _ageController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: false), // Only allow integers
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Ensure only digits are entered
            ],
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: _ageUnit,
          onChanged: (value) {
            setState(() {
              _ageUnit = value!;
            });
          },
          items: _ageUnits.map((String unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
        ),
      ],
    );
  }


  Widget _buildDropdownRow(
      String label,
      String selectedValue,
      List<String> options,
      ValueChanged<String?> onChanged,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: options.contains(selectedValue) ? selectedValue : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: onChanged,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}


