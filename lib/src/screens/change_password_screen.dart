import 'package:flutter_application_2/src/services/auth_service.dart';
import 'package:flutter_application_2/src/widgets/app_bottom_nav.dart';
import 'package:flutter_application_2/src/screens/dashboard_screen.dart';
import 'package:flutter_application_2/src/screens/notif_screen.dart';
import 'package:flutter_application_2/src/screens/search_screen.dart';
import 'package:flutter_application_2/src/screens/schedule_screen.dart';
import 'package:flutter_application_2/src/screens/history_screen.dart';
import 'package:flutter_application_2/src/screens/pet_profile.dart'; // Import ProfileScreen

class ChangePasswordScreen extends StatefulWidget {
  final int currentIndex;

  const ChangePasswordScreen({super.key, this.currentIndex = 0});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late int _currentPage;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isLoading = false;

  // Visibility state variables for passwords
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex;
  }

  void _toggleCurrentPasswordVisibility() {
    setState(() {
      _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _isNewPasswordVisible = !_isNewPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  Future<void> _changePassword(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final String currentPassword = _currentPasswordController.text.trim();
      final String newPassword = _newPasswordController.text.trim();
      final String confirmPassword = _confirmPasswordController.text.trim();

      if (newPassword != confirmPassword) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New passwords do not match')),
          );
        }
        return;
      }

      await AuthService().changePassword(currentPassword, newPassword);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password successfully changed!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    setState(() {
      isLoading = false;
    });
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
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(currentIndex: 0),
                      ),
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
                  icon: const Icon(Icons.settings, color: Colors.yellowAccent),
                  iconSize: 30.0,
                  onPressed: () {
                    // Already on Settings screen, do nothing
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Current Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _currentPasswordController,
                obscureText: !_isCurrentPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF2E7D32)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isCurrentPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF2E7D32),
                    ),
                    onPressed: _toggleCurrentPasswordVisibility,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Enter your current password',
                  labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'New Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                obscureText: !_isNewPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF2E7D32)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF2E7D32),
                    ),
                    onPressed: _toggleNewPasswordVisibility,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Enter new password',
                  labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Confirm New Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF2E7D32)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF2E7D32),
                    ),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Confirm new password',
                  labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (!isLoading) _changePassword(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: widget.currentIndex),
    );
  }
}
