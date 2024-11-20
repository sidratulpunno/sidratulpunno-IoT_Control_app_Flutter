import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot/resources/auth_method.dart';
import 'package:iot/screens/profile_screen.dart';
import 'package:iot/utils/colors.dart';
import 'package:iot/widgets/light_card.dart';

import '../resources/firestore_methods.dart';
import '../widgets/ac_card.dart';
import '../widgets/door_lock_card.dart';
import '../widgets/fan_card.dart';
import '../widgets/geyser_card.dart';

class SmartHomeScreen extends StatefulWidget {
  const SmartHomeScreen({super.key});

  @override
  State<SmartHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<SmartHomeScreen> {
  final AuthMethods _authMethods = AuthMethods();
  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  Future<void> _confirmSignOut() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
    if (shouldLogout == true) {
      _authMethods.signOut(context);
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  final List<Widget> _pages = [
    SmartHomeControlScreen(),
    ProfileScreen(), // Placeholder for profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text('Smart Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _confirmSignOut,
          ),
        ],
      ),
      body: _pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: footerColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: onPageChanged,
        currentIndex: _page,
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 14,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home Control',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class SmartHomeControlScreen extends StatelessWidget {
  final FireStoreMethods _firestoreMethods = FireStoreMethods();

  void _onDeviceUpdate(String deviceName, Map<String, dynamic> newState) {
    _firestoreMethods.updateDeviceState(deviceName, newState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8, // Adjust aspect ratio to control height/width
          ),
          itemCount: 6, // Update based on the number of device cards
          itemBuilder: (context, index) {
            // Define each card based on the index
            switch (index) {
              case 0:
                return _buildSizedCard(LightCard(
                  deviceName: 'Living Room Light',
                  initialStatus: true,
                  onToggle: (status) {
                    print('Living Room Light: $status');
                    _onDeviceUpdate('Living Room Light', {'status': status});
                  },
                ));
              case 1:
                return _buildSizedCard(LightCard(
                  deviceName: 'Bedroom Light',
                  initialStatus: false,
                  onToggle: (status) {
                    print('Bedroom Light: $status');
                    _onDeviceUpdate('Bedroom Light', {'status': status});
                  },
                ));
              case 2:
                return _buildSizedCard(FanCard(
                  deviceName: 'Living Room Fan',
                  initialStatus: true,
                  initialSpeed: 3,
                  onToggle: (status) {
                    print('Fan is ${status ? "On" : "Off"}');
                    _onDeviceUpdate('Living Room Fan', {'status': status});
                  },
                  onSpeedChange: (speed) {
                    print('Fan speed: $speed');
                    _onDeviceUpdate('Living Room Fan', {'speed': speed});
                  },
                ));
              case 3:
                return _buildSizedCard(ACCard(
                  deviceName: 'Bedroom AC',
                  initialStatus: false,
                  initialTemperature: 24.0,
                  onToggle: (status) {
                    print('AC is ${status ? "On" : "Off"}');
                    _onDeviceUpdate('Bedroom AC', {'status': status});
                  },
                  onTemperatureChange: (temp) {
                    print('AC temperature: $temp°C');
                    _onDeviceUpdate('Bedroom AC', {'temperature': temp});
                  },
                ));
              case 4:
                return _buildSizedCard(DoorLockCard(
                  deviceName: 'Main Door Lock',
                  initialStatus: true,
                  onToggle: (locked) {
                    print('Door is ${locked ? "Locked" : "Unlocked"}');
                    _onDeviceUpdate('Main Door Lock', {'locked': locked});
                  },
                ));
              default:
                return SizedBox.shrink(); // Just in case
            }
          },
        ),
      ),
    );
  }

  // Helper function to create a SizedBox-wrapped Card for consistent sizing
  Widget _buildSizedCard(Widget child) {
    return SizedBox(
      width: 150,
      height: 200,
      child: child,
    );
  }
}