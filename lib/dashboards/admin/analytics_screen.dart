import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Future<Map<String, dynamic>> getCounts() async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    final events = await FirebaseFirestore.instance.collection('events').get();

    int totalUsers = users.docs.length;
    int ngoCount = users.docs.where((doc) => doc['role'] == 'NGO').length;
    int volunteerCount = users.docs.where((doc) => doc['role'] == 'Volunteer').length;

    return {
      'users': totalUsers,
      'ngos': ngoCount,
      'volunteers': volunteerCount,
      'events': events.docs.length,
    };
  }

  static const Color themeColor = Color(0xFF5B2C6F); // Deep purple

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: themeColor,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getCounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Failed to load analytics.'));
          }

          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              StatCard(label: 'Total Users', value: data['users'].toString(), icon: Icons.groups_rounded),
              StatCard(label: 'NGOs', value: data['ngos'].toString(), icon: Icons.business_rounded),
              StatCard(label: 'Volunteers', value: data['volunteers'].toString(), icon: Icons.volunteer_activism_rounded),
              StatCard(label: 'Events', value: data['events'].toString(), icon: Icons.event_note_rounded),
            ],
          );
        },
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  static const Color themeColor = Color(0xFF5B2C6F);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: themeColor, size: 30),
        title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
