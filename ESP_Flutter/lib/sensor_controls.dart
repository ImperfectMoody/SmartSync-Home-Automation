import 'package:flutter/material.dart';

Widget buildSensorCard(
    String label, String? value, String unit, Color color, IconData icon) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            value != null ? "$value$unit" : "Fetching...",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: value != null ? double.parse(value) / 100 : 0,
            backgroundColor: color.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    ),
  );
}

Widget buildControlCard(
    String label, bool value, Function(bool) toggleFunction, Color color) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

Widget buildLedControl(bool isLedOn, Function(bool) toggleLed) {
  return buildControlCard("LED Control", isLedOn, toggleLed, Colors.green);
}

Widget buildFanControl(bool isFanOn, Function(bool) toggleFan) {
  return buildControlCard("Fan Control", isFanOn, toggleFan, Colors.blue);
}

Widget buildMachineControl(bool isMachineOn, Function(bool) toggleMachine) {
  return buildControlCard("Machine Control", isMachineOn, toggleMachine, Colors.red);
}