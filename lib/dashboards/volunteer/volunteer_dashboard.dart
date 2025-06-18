// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class VolunteerDashboard extends StatelessWidget {
  const VolunteerDashboard({super.key});

  // Same color as NGO/Admin dashboards
  static const Color themeColor   = Color(0xFF5B2C6F); // Deep Purple
  static const Color gradientEnd  = Color(0xFF9B59B6); // Lighter Purple

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Dashboard'),
        backgroundColor: themeColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [themeColor, gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.volunteer_activism, size: 40, color: Colors.white),
                  SizedBox(height: 10),
                  Text('Welcome Volunteer',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            _drawerItem(context, Icons.event_available, 'Discover Events',
                '/volunteer/discover-events'),
            _drawerItem(context, Icons.badge, 'My Profile & Badges',
                '/volunteer/profile'),
            _drawerItem(context, Icons.card_membership, 'Certificates',
                '/volunteer/certificates'),
            _drawerItem(context, Icons.feedback, 'Give Feedback',
                '/volunteer/feedback'),
            _drawerItem(context, Icons.reviews, 'Show Feedback',
                '/volunteer/myfeedback'),
            const Divider(),
            _drawerItem(context, Icons.logout, 'Logout', '/login',
                replace: true),
          ],
        ),
      ),
      body: Container(
       
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to your Volunteer Dashboard 👋',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Quick Actions:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _quickAction(context, Icons.event, 'Discover Events',
                      '/volunteer/discover-events'),
                  _quickAction(context, Icons.badge, 'My Profile',
                      '/volunteer/profile'),
                  _quickAction(context, Icons.feedback, 'Give Feedback',
                      '/volunteer/feedback'),
                  _quickAction(context, Icons.reviews, 'View Feedback',
                      '/volunteer/myfeedback'),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /* ---------- helpers ---------- */

  static Widget _drawerItem(BuildContext context, IconData icon, String label,
      String route,
      {bool replace = false}) {
    return ListTile(
      leading: Icon(icon, color: themeColor),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        replace
            ? Navigator.pushReplacementNamed(context, route)
            : Navigator.pushNamed(context, route);
      },
    );
  }

  static Widget _quickAction(
      BuildContext context, IconData icon, String label, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: themeColor.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: themeColor, size: 30),
            const SizedBox(height: 10),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
