import 'package:flutter/material.dart';
import '../models/ventilator_data.dart';

class VitalSignCard extends StatelessWidget {
  final Variable variable;
  final Color color;

  const VitalSignCard({super.key, required this.variable, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0a1931),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              variable.name,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              variable.value,
              style: TextStyle(
                  color: color,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              variable.unit,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
