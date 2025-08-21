import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_vitals_provider.dart';
import '../providers/ventilator_provider.dart';
import '../providers/infusion_pump_provider.dart';
import '../widgets/ventilator_variable_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
        title: const Text('Alarm Panel - Bed 20'),
    elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return _buildWideLayout();
            } else {
              return _buildNarrowLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildWideLayout() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 3, child: _buildVitalsCard()),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildPumpsCard()),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 1,
          child: _buildVentilatorCard(),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        Flexible(flex: 2, child: _buildVitalsCard()),
        const SizedBox(height: 8),
        Flexible(flex: 2, child: _buildPumpsCard()),
        const SizedBox(height: 8),
        Flexible(flex: 1, child: _buildVentilatorCard()),
      ],
    );
  }

  Widget _buildVitalsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vital Signs Monitor - Prolife PRO 12®',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<PatientVitalsProvider>(
                builder: (context, provider, child) {
                  if (provider.variables.isEmpty) {
                    return const Center(child: Text('No vital signs data.'));
                  }
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: provider.variables.length,
                    itemBuilder: (context, index) {
                      final variable = provider.variables.values.elementAt(index);
                      return VentilatorVariableCard(variable: variable);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPumpsCard() {
    return Card(
      color: const Color(0xFF16223a),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Infusion Pumps - Samtronic Icatu 4.0®',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<InfusionPumpProvider>(
                builder: (context, provider, child) {
                  if (provider.pumps.isEmpty) {
                    return const Center(child: Text('No infusion pump data.'));
                  }
                  return ListView.builder(
                    itemCount: provider.pumps.length,
                    itemBuilder: (context, index) {
                      final pump = provider.pumps.values.elementAt(index);
                      final hasAlarm = pump.state != 'ACTIVE' || pump.message != 'NÃO HÁ ALARMES ATIVOS';
                      final statusColor = hasAlarm ? Colors.red.shade400 : Colors.green.shade400;
                      return Container(
                        padding: const EdgeInsets.all(12.0),
                        margin: const EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Alarm - Pump ${pump.pumpSerialNumber}'),
                            Row(
                              children: [
                                Text(
                                  hasAlarm ? 'ALARM' : 'NO ALARMS',
                                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Container(width: 12, height: 12, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVentilatorCard() {
    return Card(
      color: const Color(0xFF16223a),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mechanical Ventilator - Tecme graphnet ts+®',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Consumer<VentilatorProvider>(
                      builder: (context, provider, child) {
                        if (provider.variables.isEmpty) {
                          return const Center(child: Text('No ventilator data.'));
                        }
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: provider.variables.length,
                          itemBuilder: (context, index) {
                            final variable = provider.variables.values.elementAt(index);
                            return VentilatorVariableCard(variable: variable);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Consumer<VentilatorProvider>(
                      builder: (context, provider, child) {
                        final alarm = provider.currentAlarm;
                        final hasAlarm = alarm != null;
                        final statusColor = hasAlarm ? Colors.red.shade400 : Colors.green.shade400;
                        return Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2c3e50),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Ventilator Alarm', style: TextStyle(color: Colors.white)),
                              const SizedBox(height: 8),
                              Text(
                                hasAlarm ? alarm.id : 'NO ALARMS',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
