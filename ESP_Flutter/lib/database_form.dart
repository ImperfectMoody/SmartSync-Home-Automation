import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'sensor_controls.dart';
import 'instructions.dart';
import 'gauge.dart';

// Define a modern dark color palette
const Color darkBackgroundColor = Color(0xFF121212); // Dark background
const Color darkCardColor = Color(0xFF1E1E1E); // Dark card color
const Color darkTextColor = Color(0xFFFFFFFF); // White text
const Color darkPrimaryColor = Color(0xFFBB86FC); // Purple accent
const Color darkSecondaryColor = Color(0xFF03DAC6); // Teal accent
const Color darkErrorColor = Color(0xFFCF6679); // Error color

class DatabaseForm extends StatefulWidget {
  @override
  _DatabaseFormState createState() => _DatabaseFormState();
}

class _DatabaseFormState extends State<DatabaseForm> {
  String? temperature;
  String? humidity;
  bool isLedOn = false;
  bool isFanOn = false;
  bool isMachineOn = false;
  Timer? _timer;
  String connectionStatus = "idle";
  String firebaseStatus = "connected";
  DateTime? _lastBackPressedTime; // Track the last back button press time

  // Handle back button press (double-tap to exit)
  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressedTime == null ||
        now.difference(_lastBackPressedTime!) > Duration(seconds: 2)) {
      // If the back button is pressed for the first time or after 2 seconds
      _lastBackPressedTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return false; // Don't exit the app
    }
    // If the back button is pressed twice within 2 seconds
    return true; // Exit the app
  }

  // Fetch data from Firebase
  void fetchData() async {
    var url =
        "https://homeautomation-esp-9000c-default-rtdb.firebaseio.com/sensor.json";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = data['temperature'].toString();
          humidity = data['humidity'].toString();
          connectionStatus = "connected";
          firebaseStatus = "connected";
        });
      } else {
        setState(() {
          connectionStatus = "disconnected";
          firebaseStatus = "disconnected";
        });
      }
    } catch (error) {
      setState(() {
        connectionStatus = "disconnected";
        firebaseStatus = "disconnected";
      });
    }
  }

  // Toggle LED state
  void toggleLed(bool value) async {
    var url =
        "https://homeautomation-esp-9000c-default-rtdb.firebaseio.com/led.json";
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode({"state": value ? 1 : 0}),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLedOn = value;
          firebaseStatus = "connected";
        });
      }
    } catch (error) {
      setState(() {
        firebaseStatus = "disconnected";
      });
    }
  }

  // Toggle Fan state
  void toggleFan(bool value) async {
    var url =
        "https://homeautomation-esp-9000c-default-rtdb.firebaseio.com/fan.json";
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode({"state": value ? 1 : 0}),
      );

      if (response.statusCode == 200) {
        setState(() {
          isFanOn = value;
          firebaseStatus = "connected";
        });
      }
    } catch (error) {
      setState(() {
        firebaseStatus = "disconnected";
      });
    }
  }

  // Toggle Machine state
  void toggleMachine(bool value) async {
    var url =
        "YOUR_FIREBASE_URL";
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode({"state": value ? 1 : 0}),
      );

      if (response.statusCode == 200) {
        setState(() {
          isMachineOn = value;
          firebaseStatus = "connected";
        });
      }
    } catch (error) {
      setState(() {
        firebaseStatus = "disconnected";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press
      child: Scaffold(
        backgroundColor: darkBackgroundColor, // Set dark background
        appBar: AppBar(
          title: Text(
            "Real-Time Sensor Data",
            style: TextStyle(color: darkTextColor),
          ),
          centerTitle: true,
          backgroundColor: darkCardColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.wifi,
                    color: connectionStatus == "connected"
                        ? Colors.green
                        : connectionStatus == "idle"
                            ? Colors.blue
                            : Colors.red,
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.sync,
                    color: firebaseStatus == "connected" ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: _buildHomePage(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InstructionsPage()),
              );
            }
          },
          backgroundColor: darkCardColor,
          selectedItemColor: darkPrimaryColor,
          unselectedItemColor: darkTextColor.withOpacity(0.6),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help),
              label: 'Instructions',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Temperature and Humidity Gauges
              Row(
                children: [
                  Expanded(
                    child: Gauge(
                      label: "Temperature",
                      value: temperature,
                      unit: "°C",
                      icon: Icons.thermostat,
                      iconColor: darkPrimaryColor,
                      maxValue: 80, // Temperature range: 0 to 80
                      minLabel: "0°C", // Min value label
                      maxLabel: "80°C", // Max value label
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Gauge(
                      label: "Humidity",
                      value: humidity,
                      unit: "%",
                      icon: Icons.water_drop,
                      iconColor: darkSecondaryColor,
                      maxValue: 100, // Humidity range: 0 to 100
                      minLabel: "0%", // Min value label
                      maxLabel: "100%", // Max value label
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // LED Control
              buildControlCard(
                "LED Control",
                isLedOn,
                toggleLed,
                darkPrimaryColor,
              ),
              SizedBox(height: 20),
              // Fan Control
              buildControlCard(
                "Fan Control",
                isFanOn,
                toggleFan,
                darkSecondaryColor,
              ),
              SizedBox(height: 20),
              // Machine Control
              buildControlCard(
                "Machine Control",
                isMachineOn,
                toggleMachine,
                darkErrorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildControlCard(
    String label,
    bool value,
    Function(bool) toggleFunction,
    Color color,
  ) {
    return Card(
      elevation: 5,
      color: darkCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkTextColor,
              ),
            ),
            Switch(
              value: value,
              onChanged: toggleFunction,
              activeColor: color,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}