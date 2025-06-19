import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_loop/theme_provider.dart'; // Make sure this path matches your project

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color themeColor = Color(0xFF5B2C6F); // Deep purple

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: themeColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const SizedBox(height: 24),
          const Text(
            'Appearance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.isDark,
            onChanged: themeProvider.toggle,
            secondary: const Icon(Icons.brightness_6),
            activeColor: themeColor,
          ),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              '⚙️ More settings coming soon...',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
