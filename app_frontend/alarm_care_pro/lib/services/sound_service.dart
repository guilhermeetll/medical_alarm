import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _volume = 1.0;
  bool _isMuted = false;

  double get volume => _volume;
  bool get isMuted => _isMuted;

  void setVolume(double newVolume) {
    _volume = newVolume;
    if (!_isMuted) {
      _audioPlayer.setVolume(newVolume);
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _audioPlayer.setVolume(0);
    } else {
      _audioPlayer.setVolume(_volume);
    }
  }

  Future<void> playAlarm(String priority) async {
    if (_isMuted) return;

    String soundPath;
    switch (priority) {
      case 'HI':
        soundPath = 'sounds/high_alarm.mp3';
        break;
      case 'MED':
        soundPath = 'sounds/medium_alarm.mp3';
        break;
      case 'LOW':
        soundPath = 'sounds/low_alarm.mp3';
        break;
      default:
        return;
    }
    await _audioPlayer.play(AssetSource(soundPath));
  }

  void stopAlarm() {
    _audioPlayer.stop();
  }
}
