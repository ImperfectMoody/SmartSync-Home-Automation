import 'package:flutter/material.dart';
import 'dart:math';

class Gauge extends StatelessWidget {
  final String label;
  final String? value;
  final String unit;
  final IconData icon;
  final Color iconColor;
  final double maxValue;
  final String minLabel; // Min value label
  final String maxLabel; // Max value label

  const Gauge({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.iconColor,
    required this.maxValue,
    required this.minLabel,
    required this.maxLabel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse value safely
    double parsedValue = double.tryParse(value ?? "0") ?? 0.0;

    // Normalize value based on maxValue (0 to maxValue)
    double normalizedValue = (parsedValue.clamp(0, maxValue)) / maxValue;

    // Dynamic gauge color (Green → Yellow → Red)
    Color gaugeColor = Color.lerp(Colors.green, Colors.red, normalizedValue)!;

    // Convert value to progress percentage (in radians)
    double progress = normalizedValue * pi; // Convert to radians

    return Card(
      elevation: 5,
      color: Color(0xFF1E1E1E), // Dark card color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label and Icon
            Row(
              children: [
                Icon(icon, size: 30, color: iconColor),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent text cutoff
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Gauge and Min/Max Labels
            Column(
              children: [
                CustomPaint(
                  size: Size(150, 75),
                  painter: _GaugePainter(
                    barColor: gaugeColor,
                    progressAngle: progress,
                  ),
                  child: Container(
                    width: 150,
                    height: 85,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      value != null ? "$value $unit" : "Fetching...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Min and Max Labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      minLabel,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7), // Light gray text
                      ),
                    ),
                    Text(
                      maxLabel,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7), // Light gray text
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Gauge Painter
class _GaugePainter extends CustomPainter {
  final Color barColor;
  final double progressAngle;

  _GaugePainter({required this.barColor, required this.progressAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = barColor.withOpacity(0.2) // Dark background arc
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = barColor // Progress arc color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height),
      radius: size.width / 2,
    );

    // Draw background semicircle
    canvas.drawArc(rect, pi, pi, false, backgroundPaint);

    // Draw progress arc
    canvas.drawArc(rect, pi, progressAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}