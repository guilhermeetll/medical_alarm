import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class SettingsProvider with ChangeNotifier {
  final SoundService _soundService = SoundService();
  bool _isDarkMode = false;

  double get volume => _soundService.volume;
  bool get isMuted => _soundService.isMuted;
  bool get isDarkMode => _isDarkMode;

  void setVolume(double newVolume) {
    _soundService.setVolume(newVolume);
    notifyListeners();
  }

  void toggleMute() {
    _soundService.toggleMute();
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
