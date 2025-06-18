import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  // Consistent brand color (deep purple)
  static const Color themeColor = Color(0xFF5B2C6F);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int totalUsers = 0;
  int pendingNgos = 0;
  int activeEvents = 0;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final usersSnap = await FirebaseFirestore.instance.collection('users').get();
    final eventsSnap = await FirebaseFirestore.instance.collection('events').get();

    setState(() {
      totalUsers = usersSnap.docs.length;

      pendingNgos = usersSnap.docs.where((doc) {
        final data = doc.data();
        final role = data['role'];
        final isVerified = data['isVerified'] ?? false;
        return role == 'NGO' && isVerified == false;
      }).length;

      activeEvents = eventsSnap.docs.where((doc) {
        final data = doc.data();
        return (data['isApproved'] ?? false) == true;
      }).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AdminDashboard.themeColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  // Slightly different gradient (deep teal ➜ mint) to stand out
                  colors: [Color(0xFF0f2027), Color(0xFF2c5364)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.admin_panel_settings_rounded,
                      size: 48, color: Colors.white),
                  SizedBox(height: 12),
                  Text('Admin Panel',
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                ],
              ),
            ),
            _drawerItem(context, Icons.group_rounded, 'Manage Users',
                '/admin/manage-users'),
            _drawerItem(context, Icons.verified_user_rounded, 'Verify NGOs',
                '/admin/verify-ngos'),
            _drawerItem(context, Icons.event_note_rounded, 'Moderate Events',
                '/admin/manage-events'),
            _drawerItem(context, Icons.analytics_rounded, 'Analytics',
                '/admin/analytics'),
            _drawerItem(context, Icons.settings_rounded, 'Settings',
                '/admin/settings'),
            const Divider(),
            _drawerItem(context, Icons.logout_rounded, 'Logout', '/login',
                replace: true),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin 👋',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SummaryCard(
                  label: 'Total Users',
                  count: totalUsers,
                  icon: Icons.people_alt_rounded,
                ),
                SummaryCard(
                  label: 'Pending NGOs',
                  count: pendingNgos,
                  icon: Icons.hourglass_empty_rounded,
                ),
                SummaryCard(
                  label: 'Approved Events',
                  count: activeEvents,
                  icon: Icons.event_available_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String label,
      String route,
      {bool replace = false}) {
    return ListTile(
      leading: Icon(icon, color: AdminDashboard.themeColor),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        replace
            ? Navigator.pushReplacementNamed(context, route)
            : Navigator.pushNamed(context, route);
      },
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 34, color: AdminDashboard.themeColor),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 6),
              Text(count.toString(),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
