import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/infusion_pump_provider.dart';

class PumpsScreen extends StatelessWidget {
  const PumpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a1931),
      appBar: AppBar(
        title: const Text('Bombas de Infusão'),
        backgroundColor: const Color(0xFF0a1931),
      ),
      body: Consumer<InfusionPumpProvider>(
        builder: (context, provider, child) {
          if (provider.pumps.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 600 ? 2 : 1,
                  childAspectRatio: 2.5,
                ),
                itemCount: provider.pumps.length,
                itemBuilder: (context, index) {
                  final pump = provider.pumps.values.elementAt(index);
                  final bool hasAlarm = pump.state != 'ACTIVE' || pump.message != 'NÃO HÁ ALARMES ATIVOS';
                  final Color statusColor = hasAlarm ? Colors.red : Colors.green;
                  
                  String formattedDate = '';
                  try {
                    if (pump.updatedAt.isNotEmpty) {
                      final dateTime = DateTime.parse(pump.updatedAt);
                      formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
                    }
                  } catch (e) {
                    // Handle parsing error if necessary
                  }

                  return Card(
                    color: const Color(0xFF16223a),
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pump: ${pump.pumpSerialNumber}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            pump.message,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Updated: $formattedDate',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
