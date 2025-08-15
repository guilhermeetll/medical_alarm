import 'dart:async';
import 'package:flutter/material.dart';
import '../models/patient_vitals.dart';
import '../models/ventilator_data.dart';

class PatientVitalsProvider with ChangeNotifier {
  Map<String, Variable> _variables = {};
  Map<String, List<double>> _variableHistory = {};
  List<Alarm> _alarms = [];
  Map<String, DateTime> _variableTimestamps = {};
  Timer? _timer;

  Map<String, Variable> get variables => _variables;
  Map<String, List<double>> get variableHistory => _variableHistory;
  List<Alarm> get alarms => _alarms;

  PatientVitalsProvider() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkTimeouts();
    });
  }

  void setVitals(Map<String, dynamic> json) {
    final newData = PatientVitals.fromJson(json);

    for (var variable in newData.variables) {
      _variables[variable.name] = variable;
      _variableTimestamps[variable.name] = DateTime.now();

      if (!_variableHistory.containsKey(variable.name)) {
        _variableHistory[variable.name] = [];
      }
      final double? value = double.tryParse(variable.value);
      if (value != null) {
        _variableHistory[variable.name]!.add(value);
        if (_variableHistory[variable.name]!.length > 20) {
          _variableHistory[variable.name]!.removeAt(0);
        }
      }
    }

    if (newData.alarms.isNotEmpty) {
      _alarms = newData.alarms;
    }
    
    notifyListeners();
  }

  void _checkTimeouts() {
    bool changed = false;
    final now = DateTime.now();
    final keysToRemove = <String>[];
    _variableTimestamps.forEach((name, timestamp) {
      if (now.difference(timestamp).inSeconds > 30) {
        keysToRemove.add(name);
      }
    });

    if (keysToRemove.isNotEmpty) {
      for (var key in keysToRemove) {
        _variables.remove(key);
        _variableTimestamps.remove(key);
      }
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
