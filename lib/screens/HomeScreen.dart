import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tot_app/screens/DogsScreen.dart';
import 'package:tot_app/screens/MapTrackingScreen.dart';
import 'package:tot_app/controllers/DogController.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final DogController controller = Get.put(DogController());

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Create separate widgets for each screen content
  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return DogsScreen();
      case 1:
        return MapTrackingScreen();
      default:
        return Center(child: Text("Unknown screen"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // For large screens (e.g., tablets), display content side by side
            return Row(children: [Expanded(child: _getScreen(_selectedIndex))]);
          } else {
            // For small screens (e.g., phones), display content vertically
            return _getScreen(_selectedIndex);
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor:
            Colors.white, // Custom background color for the bottom bar
        selectedItemColor: Colors.green.shade700, // Color for selected item
        unselectedItemColor: Colors.grey.shade600, // Color for unselected items
        showSelectedLabels: true, // Show labels when selected
        showUnselectedLabels:
            false, // Hide labels when unselected (for modern look)
        selectedFontSize: 14, // Smaller font size for a sleek look
        unselectedFontSize: 12, // Smaller font size for unselected items
        elevation: 8, // subtle shadow for a modern effect
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pets, size: 28), // Larger icon for a modern feel
            label: 'Dogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, size: 28),
            label: 'Live Location',
          ),
        ],
      ),
    );
  }
}
