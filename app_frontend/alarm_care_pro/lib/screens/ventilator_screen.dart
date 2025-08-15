import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ventilator_provider.dart';
import '../widgets/ventilator_variable_card.dart';

class VentilatorScreen extends StatelessWidget {
  const VentilatorScreen({super.key});

  Color _getAlarmColor(String? priority) {
    switch (priority) {
      case 'HI':
        return Colors.red.shade700;
      case 'MED':
        return Colors.yellow.shade700;
      case 'LOW':
        return Colors.blue.shade700;
      default:
        return const Color(0xFF0a1931);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VentilatorProvider>(
      builder: (context, provider, child) {
        final alarmColor = _getAlarmColor(provider.currentAlarm?.priority);
        return Scaffold(
          backgroundColor: const Color(0xFF0a1931),
          appBar: AppBar(
            title: const Text('Ventilador'),
            backgroundColor: alarmColor,
            elevation: 0,
          ),
          body: Column(
            children: [
              if (provider.currentAlarm != null)
                Container(
                  color: alarmColor,
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.currentAlarm!.id,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => provider.clearAlarm(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: alarmColor,
                        ),
                        child: const Text('Clear Alarm'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: provider.variables.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          return GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
                              childAspectRatio: 1.2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: provider.variables.length,
                            itemBuilder: (context, index) {
                              final variable =
                                  provider.variables.values.elementAt(index);
                              return VentilatorVariableCard(variable: variable);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
