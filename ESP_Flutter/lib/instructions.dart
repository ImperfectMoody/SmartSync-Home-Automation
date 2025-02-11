import 'package:flutter/material.dart';

// Define a modern dark color palette
const Color darkBackgroundColor = Color(0xFF121212); // Dark background
const Color darkCardColor = Color(0xFF1E1E1E); // Dark card color
const Color darkTextColor = Color(0xFFFFFFFF); // White text
const Color darkPrimaryColor = Color(0xFFBB86FC); // Purple accent

class InstructionsPage extends StatelessWidget {
  final List<Map<String, dynamic>> instructions = [
    {
      "icon": Icons.wifi,
      "title": "Connect to Wi-Fi",
      "desc": "Ensure your device is connected to Wi-Fi for real-time data updates."
    },
    {
      "icon": Icons.thermostat,
      "title": "Monitor Temperature & Humidity",
      "desc": "View live sensor data for temperature and humidity."
    },
    {
      "icon": Icons.power_settings_new,
      "title": "Control Devices",
      "desc": "Toggle switches to control LED, Fan, Heater, AC, and Motor."
    },
    {
      "icon": Icons.sync,
      "title": "Firebase Status",
      "desc": "Green icons indicate successful connection to Firebase."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor, // Dark background
      appBar: AppBar(
        title: Text(
          "Instructions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: darkTextColor, // White text
          ),
        ),
        centerTitle: true,
        backgroundColor: darkCardColor, // Dark card color
        elevation: 10,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: instructions.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: darkCardColor, // Dark card color
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: darkPrimaryColor, // Purple accent
                child: Icon(
                  instructions[index]['icon'],
                  color: darkTextColor, // White icon
                ),
              ),
              title: Text(
                instructions[index]['title'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkTextColor, // White text
                ),
              ),
              subtitle: Text(
                instructions[index]['desc'],
                style: TextStyle(
                  fontSize: 16,
                  color: darkTextColor.withOpacity(0.8), // Light gray text
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}