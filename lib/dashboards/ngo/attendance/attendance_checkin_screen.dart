import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:local_loop/services/attendance_service.dart';

class AttendanceCheckInScreen extends StatefulWidget {
  final String eventId;
  final String eventTitle;

  const AttendanceCheckInScreen({
    super.key,
    required this.eventId,
    required this.eventTitle,
  });

  @override
  State<AttendanceCheckInScreen> createState() => _AttendanceCheckInScreenState();
}

class _AttendanceCheckInScreenState extends State<AttendanceCheckInScreen> {
  static const Color themeColor = Color(0xFF5B2C6F); // Deep Purple
  final _attendanceService = AttendanceService();

  // Cache for user names
  final Map<String, String> _userNames = {};

  Future<String> _getUserName(String userId) async {
    if (_userNames.containsKey(userId)) return _userNames[userId]!;

    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final name = doc.data()?['name'] ?? 'Unknown';
    _userNames[userId] = name;
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance: ${widget.eventTitle}'),
        backgroundColor: themeColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5B2C6F), // Dark purple
              Color(0xFF8E44AD), // Medium purple
              Color(0xFFD2B4DE), // Light lavender
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('event_registrations')
              .where('eventId', isEqualTo: widget.eventId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            final registrations = snapshot.data!.docs;

            if (registrations.isEmpty) {
              return const Center(
                child: Text(
                  'No volunteers registered for this event.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: registrations.length,
              itemBuilder: (context, index) {
                final doc = registrations[index];
                final data = doc.data() as Map<String, dynamic>;
                final regId = doc.id;
                final userId = data['userId'];
                final checkIn = data['checkIn']?.toDate();
                final checkOut = data['checkOut']?.toDate();
                final hours = data['hoursServed'];

                return FutureBuilder<String>(
                  future: _getUserName(userId),
                  builder: (context, nameSnapshot) {
                    final name = nameSnapshot.data ?? 'Loading...';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text('Name: $name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (checkIn != null)
                              Text("🕒 Check-in: ${checkIn.toLocal()}"),
                            if (checkOut != null)
                              Text("✅ Check-out: ${checkOut.toLocal()}"),
                            if (hours != null)
                              Text("⏱️ Hours Served: $hours h"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.login, color: Colors.orange),
                              tooltip: 'Check In',
                              onPressed: checkIn == null
                                  ? () => _attendanceService.markCheckIn(regId)
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout, color: Colors.green),
                              tooltip: 'Check Out',
                              onPressed: (checkIn != null && checkOut == null)
                                  ? () => _attendanceService.markCheckOut(regId, userId)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
