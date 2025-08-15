import 'dart:async';
import 'package:flutter/material.dart';
import '../models/ventilator_data.dart';
import '../services/sound_service.dart';

class VentilatorProvider with ChangeNotifier {
  Map<String, Variable> _variables = {};
  Alarm? _currentAlarm;
  final SoundService _soundService = SoundService();
  Map<String, DateTime> _variableTimestamps = {};
  Timer? _timer;

  Map<String, Variable> get variables => _variables;
  Alarm? get currentAlarm => _currentAlarm;

  VentilatorProvider() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkTimeouts();
    });
  }

  void setData(Map<String, dynamic> json) {
    final newData = VentilatorData.fromJson(json);

    for (var variable in newData.variables) {
      _variables[variable.name] = variable;
      _variableTimestamps[variable.name] = DateTime.now();
    }

    if (newData.alarms.isNotEmpty) {
      // Check for deactivation of the current alarm first
      for (var alarm in newData.alarms) {
        if (alarm.state == 'INACTIVE' && _currentAlarm?.id == alarm.id) {
          _currentAlarm = null;
          _soundService.stopAlarm();
          break; // Exit after finding the deactivation message
        }
      }

      // Find the highest priority active alarm in the new batch
      Alarm? highestPriorityNewAlarm;
      for (var alarm in newData.alarms) {
        if (alarm.state == 'ACTIVE') {
          if (highestPriorityNewAlarm == null || alarm.priorityLevel > highestPriorityNewAlarm.priorityLevel) {
            highestPriorityNewAlarm = alarm;
          }
        }
      }

      // If a new high-priority alarm was found, compare it with the current one
      if (highestPriorityNewAlarm != null) {
        if (_currentAlarm == null || highestPriorityNewAlarm.priorityLevel > _currentAlarm!.priorityLevel) {
          _currentAlarm = highestPriorityNewAlarm;
          _soundService.playAlarm(_currentAlarm!.priority);
        }
      }
    }
    
    notifyListeners();
  }

  void clearAlarm() {
    _currentAlarm = null;
    _soundService.stopAlarm();
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
