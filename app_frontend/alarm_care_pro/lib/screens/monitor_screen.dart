import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_vitals_provider.dart';
import '../widgets/vital_sign_card.dart';
import '../widgets/waveform_graph.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a1931),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PatientVitalsProvider>(
          builder: (context, provider, child) {
            if (provider.variables.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: provider.variables.entries.map((entry) {
                      final variableName = entry.key;
                      final variable = entry.value;
                      final history = provider.variableHistory[variableName] ?? [];
                      
                      double minY = 0;
                      double maxY = 100;
                      Color color = Colors.blue;

                      switch (variableName) {
                        case 'Ecg Heart Rate':
                          minY = 0;
                          maxY = 200;
                          color = Colors.red;
                          break;
                        case 'Puls Oxim Sat O2':
                          minY = 0;
                          maxY = 100;
                          color = Colors.blue;
                          break;
                        case 'Puls Oxim Puls Rate':
                          minY = 0;
                          maxY = 200;
                          color = Colors.green;
                          break;
                        case 'Tthor Resp Rate':
                          minY = 0;
                          maxY = 200;
                          color = Colors.yellow;
                          break;
                        case 'Temp':
                          minY = 0;
                          maxY = 100;
                          color = Colors.orange;
                          break;
                      }

                      return Card(
                        color: const Color(0xFF16223a),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 100,
                                  child: WaveformGraph(data: history, minY: minY, maxY: maxY, color: color),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: VitalSignCard(variable: variable, color: color),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegend('ECG', Colors.red),
                      _buildLegend('SpO2', Colors.blue),
                      _buildLegend('Pulse', Colors.green),
                      _buildLegend('Resp', Colors.yellow),
                      _buildLegend('Temp', Colors.orange),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegend(String name, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(name, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
