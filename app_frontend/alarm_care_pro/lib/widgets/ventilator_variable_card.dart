import 'package:flutter/material.dart';
import '../models/ventilator_data.dart';

class VentilatorVariableCard extends StatelessWidget {
  final Variable variable;

  const VentilatorVariableCard({super.key, required this.variable});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF16223a),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              variable.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              variable.value,
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              variable.unit,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
