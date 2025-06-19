import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NgoDashboard extends StatelessWidget {
  const NgoDashboard({super.key});

  static const Color themeColor = Color(0xFF5B2C6F); // Deep Purple

  Future<Map<String, int>> _fetchCounts() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return {'volunteers': 0, 'events': 0, 'approvedEvents': 0};

    final eventsSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('createdBy', isEqualTo: userId)
        .get();

    final approvedCount =
        eventsSnapshot.docs.where((doc) => doc['isApproved'] == true).length;

    final registrationsSnapshot = await FirebaseFirestore.instance
        .collection('event_registrations')
        .where('eventId',
            whereIn: eventsSnapshot.docs.map((e) => e.id).toList())
        .get();

    final volunteerIds =
        registrationsSnapshot.docs.map((doc) => doc['userId']).toSet();

    return {
      'events': eventsSnapshot.size,
      'approvedEvents': approvedCount,
      'volunteers': volunteerIds.length,
    };
  }

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
                  colors: [Color(0xFF4A235A), Color(0xFF7D3C98)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.account_balance, size: 40, color: Colors.white),
                  SizedBox(height: 10),
                  Text('Welcome NGO',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('ngo@email.com',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
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
      body: FutureBuilder<Map<String, int>>(
        future: _fetchCounts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: themeColor));
          }

          final stats = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to your NGO Dashboard 👋',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildStatCard('Total Events', stats['events']!, Icons.event, Colors.teal),
                _buildStatCard('Approved Events', stats['approvedEvents']!, Icons.check_circle, Colors.green),
                _buildStatCard('Registered Volunteers', stats['volunteers']!, Icons.people, Colors.deepPurple),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _buildStatCard(String title, int count, IconData icon, Color iconColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 36),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          count.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
