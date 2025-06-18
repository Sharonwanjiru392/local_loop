import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save check-in timestamp for a registration
  Future<void> markCheckIn(String registrationId) async {
    await _firestore.collection('event_registrations').doc(registrationId).update({
      'checkIn': Timestamp.now(),
    });
  }

  /// Save check-out timestamp, calculate hours served, and update totalHours
  Future<void> markCheckOut(String registrationId, String userId) async {
    final doc = await _firestore.collection('event_registrations').doc(registrationId).get();
    final data = doc.data();

    if (data == null || data['checkIn'] == null) return;

    final checkIn = data['checkIn'].toDate();
    final checkOut = DateTime.now();
    final hoursServed = checkOut.difference(checkIn).inHours;

    // 1. Update the registration document
    await _firestore.collection('event_registrations').doc(registrationId).update({
      'checkOut': Timestamp.fromDate(checkOut),
      'hoursServed': hoursServed,
    });

    // 2. Update the user's totalHours
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final currentHours = (userDoc.data()?['totalHours'] ?? 0) as int;

    await _firestore.collection('users').doc(userId).update({
      'totalHours': currentHours + hoursServed,
    });
  }
}
