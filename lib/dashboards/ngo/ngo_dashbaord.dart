import 'package:flutter/material.dart';

class NgoDashboard extends StatelessWidget {
  const NgoDashboard({super.key});

  // Use same color as AdminDashboard
  static const Color themeColor = Color(0xFF5B2C6F); // Deep Purple

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO Dashboard'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4A235A), Color(0xFF7D3C98)], // Matching Admin vibe
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.account_balance, size: 40, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Welcome NGO',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ngo@email.com', // TODO: Replace dynamically
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _drawerItem(context, Icons.add, 'Create Event', '/ngo/create-event'),
            _drawerItem(context, Icons.edit_calendar, 'Manage Events', '/ngo/manage-events'),
            const Divider(),
            _drawerItem(context, Icons.person_add_alt_1, 'Create Profile', '/ngo/profile'),
            _drawerItem(context, Icons.person_outline, 'View Profile', '/ngo/view-profile'),
            const Divider(),
            _drawerItem(context, Icons.group, 'Manage Volunteers', '/ngo/manage-volunteers'),
            _drawerItem(context, Icons.assignment, 'Track Attendance', '/ngo/attendance/select-event'),
            const Divider(),
            _drawerItem(context, Icons.logout, 'Logout', '/login', replace: true),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Welcome to your NGO Dashboard 👋',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static Widget _drawerItem(BuildContext context, IconData icon, String label, String route,
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
}
