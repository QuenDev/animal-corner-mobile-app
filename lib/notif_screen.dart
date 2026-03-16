import 'package:flutter/material.dart';
import 'package:flutter_application_2/dashboard_screen.dart';
import 'package:flutter_application_2/search_screen.dart';
import 'package:flutter_application_2/schedule_screen.dart';
import 'package:flutter_application_2/history_screen.dart';
import 'package:flutter_application_2/pet_profile.dart';
import 'package:flutter_application_2/setting_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatefulWidget {
  final int currentIndex;

  const NotificationScreen({super.key, this.currentIndex = 0});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late int _currentPage;
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = false;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex;
    _fetchNotifications();
    _initializeFirebase();
  }

  // Fetch notifications from Firebase Firestore
  Future<void> _fetchNotifications() async {
    setState(() => isLoading = true);

    // Fetch data from Firestore (replace with your collection)
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('appointments') // Collection name
          .where('status', isEqualTo: 'upcoming') // Filter for upcoming appointments (modify as needed)
          .get();

      notifications = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "title": data['appointment_name'],
          "timestamp": data['day'],
          "isRead": false,
        };
      }).toList();
    } catch (e) {
      print("Error fetching notifications: $e");
    }

    setState(() => isLoading = false);
  }

  // Clear read notifications
  void _clearReadNotifications() {
    setState(() {
      notifications.removeWhere((notification) => notification['isRead']);
    });
  }

  // Firebase Messaging initialization
  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for iOS
    messaging.requestPermission();

    // Get the token for push notifications (for debugging purposes)
    String? token = await messaging.getToken();
    print("Firebase messaging token: $token");

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message in foreground: ${message.notification?.title}");
      _showNotification(message);
    });

    // Handle background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle when app is opened from a terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked! Opening the app.");
      _showNotification(message);
    });

    // Initialize local notifications plugin
    _initializeLocalNotifications();
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling background message: ${message.messageId}");
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails('your_channel_id', 'your_channel_name'),
    
      ),
    );
  }

  // Local notifications initialization
  void _initializeLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  
   
        // Handle notification when the app is in the background or terminated
   
   

   


    // Request permission for iOS notifications
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions();
  }

  // Show notification using local notifications
  void _showNotification(RemoteMessage message) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails('your_channel_id', 'your_channel_name', importance: Importance.high, priority: Priority.high),
       
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     return WillPopScope(
     onWillPop: () async {
        // If the user is logged out, prevent going back
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen(currentIndex: 0,)),
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
                  icon: const Icon(Icons.notifications, color: Colors.yellowAccent),
                  iconSize: 30.0,
                  onPressed: () {
                    // Navigate to NotificationScreen directly from the AppBar
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationScreen(currentIndex: _currentPage)),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchNotifications,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: _clearReadNotifications,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove padding for a minimal look
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Smaller tap area
                        ),
                        child: const Text(
                          "Clear Notification",
                          style: TextStyle(
                            color: Colors.red, // Text color to match theme
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: notifications.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              return _buildNotificationTile(notifications[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
  ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: notification['isRead'] ? Colors.white : Colors.green.shade50,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          notification['isRead'] ? Icons.notifications_none : Icons.notifications,
          color: notification['isRead'] ? Colors.grey : Colors.green,
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
            color: notification['isRead'] ? Colors.black54 : Colors.black,
          ),
        ),
        subtitle: Text(
          notification['timestamp'],
          style: const TextStyle(color: Colors.black54),
        ),
        onTap: () {
          _showNotificationDetails(notification);
          setState(() {
            notification['isRead'] = true; // Mark as read when tapped
          });
        },
        trailing: _buildReadUnreadIndicator(notification),
      ),
    );
  }

  Widget _buildReadUnreadIndicator(Map<String, dynamic> notification) {
    return Icon(
      notification['isRead'] ? Icons.check_circle : Icons.circle,
      color: notification['isRead'] ? Colors.green : Colors.red,
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    // Show detailed notification on tap
    print('Notification clicked: ${notification['title']}');
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No upcoming notifications.',
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.grey.shade600,
        ),
      ),
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
        unselectedLabelStyle: const TextStyle(fontSize: 11, fontFamily: 'Montserrat'),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPage,
        onTap: (index) {
          if (index != _currentPage) {
            // If the tapped index is different from the current, navigate to the respective screen
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen(currentIndex: 4)),
                );
                break;
            }
          } else {
            // If the tapped index is the same as the current, refresh the current screen
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