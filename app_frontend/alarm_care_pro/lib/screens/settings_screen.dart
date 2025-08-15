import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a1931),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF0a1931),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Volume',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: settings.volume,
                  onChanged: (newVolume) {
                    settings.setVolume(newVolume);
                  },
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text(
                    'Mute',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: settings.isMuted,
                  onChanged: (value) {
                    settings.toggleMute();
                  },
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text(
                    'Light Mode',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: !settings.isDarkMode,
                  onChanged: (value) {
                    settings.toggleTheme();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
