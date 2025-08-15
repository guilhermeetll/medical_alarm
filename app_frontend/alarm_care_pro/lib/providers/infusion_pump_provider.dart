import 'dart:async';
import 'package:flutter/material.dart';
import '../models/infusion_pump_data.dart';

class InfusionPumpProvider with ChangeNotifier {
  Map<String, InfusionPumpData> _pumps = {};
  Map<String, DateTime> _pumpTimestamps = {};
  Timer? _timer;

  Map<String, InfusionPumpData> get pumps => _pumps;

  InfusionPumpProvider() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkTimeouts();
    });
  }

  void setData(Map<String, dynamic> json) {
    final newData = InfusionPumpData.fromJson(json);
    _pumps[newData.pumpSerialNumber] = newData;
    _pumpTimestamps[newData.pumpSerialNumber] = DateTime.now();
    notifyListeners();
  }

  void _checkTimeouts() {
    bool changed = false;
    final now = DateTime.now();
    final keysToRemove = <String>[];
    _pumpTimestamps.forEach((serialNumber, timestamp) {
      if (now.difference(timestamp).inSeconds > 30) {
        keysToRemove.add(serialNumber);
      }
    });

    if (keysToRemove.isNotEmpty) {
      for (var key in keysToRemove) {
        _pumps.remove(key);
        _pumpTimestamps.remove(key);
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
