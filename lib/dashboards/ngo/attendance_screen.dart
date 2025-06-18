// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AttendanceScreen extends StatefulWidget {
//   const AttendanceScreen({super.key});

//   @override
//   State<AttendanceScreen> createState() => _AttendanceScreenState();
// }

// class _AttendanceScreenState extends State<AttendanceScreen> {
//   String? selectedEventId;

//   Future<void> _checkIn(String volunteerId) async {
//     try {
//       await FirebaseFirestore.instance.collection('attendance').add({
//         'volunteerId': volunteerId,
//         'eventId': selectedEventId,
//         'checkInTime': Timestamp.now(),
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Volunteer checked in')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Check-in failed: $e')),
//       );
//     }
//   }

//   Future<void> _checkOut(String attendanceId) async {
//     try {
//       final checkInDoc = await FirebaseFirestore.instance.collection('attendance').doc(attendanceId).get();
//       final checkInTime = checkInDoc['checkInTime'].toDate();
//       final checkOutTime = DateTime.now();
//       final hoursServed = checkOutTime.difference(checkInTime).inMinutes / 60;

//       await FirebaseFirestore.instance.collection('attendance').doc(attendanceId).update({
//         'checkOutTime': Timestamp.fromDate(checkOutTime),
//         'hoursServed': hoursServed,
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Volunteer checked out')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Check-out failed: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     const themeColor = Color(0xFF2193b0);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Track Attendance'),
//         backgroundColor: themeColor,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance.collection('events').snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const CircularProgressIndicator();
//                 }
//                 final events = snapshot.data!.docs;
//                 return DropdownButtonFormField<String>(
//                   value: selectedEventId,
//                   hint: const Text('Select Event'),
//                   items: events.map((event) {
//                     return DropdownMenuItem(
//                       value: event.id,
//                       child: Text(event['title']),
//                     );
//                   }).toList(),
//                   onChanged: (value) => setState(() => selectedEventId = value),
//                 );
//               },
//             ),
//           ),
//           if (selectedEventId != null)
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance.collection('volunteers').snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   final volunteers = snapshot.data!.docs;

//                   return ListView.builder(
//                     itemCount: volunteers.length,
//                     itemBuilder: (context, index) {
//                       final volunteer = volunteers[index];
//                       final name = volunteer['name'] ?? '';
//                       final email = volunteer['email'] ?? '';

//                       return ListTile(
//                         title: Text(name),
//                         subtitle: Text(email),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.login, color: Colors.green),
//                               onPressed: () => _checkIn(volunteer.id),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.logout, color: Colors.red),
//                               onPressed: () async {
//                                 final query = await FirebaseFirestore.instance
//                                   .collection('attendance')
//                                   .where('volunteerId', isEqualTo: volunteer.id)
//                                   .where('eventId', isEqualTo: selectedEventId)
//                                   .get();

//                                 if (query.docs.isNotEmpty) {
//                                   await _checkOut(query.docs.first.id);
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
