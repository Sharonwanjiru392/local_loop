import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyFeedbackScreen extends StatefulWidget {
  const MyFeedbackScreen({super.key});

  @override
  State<MyFeedbackScreen> createState() => _MyFeedbackScreenState();
}

class _MyFeedbackScreenState extends State<MyFeedbackScreen> {
  // Deep‑purple palette
  static const Color themeColor  = Color(0xFF5B2C6F);
  static const Color gradientEnd = Color(0xFF9B59B6);

  Future<List<Map<String, dynamic>>> fetchMyFeedback() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in");

    final fbSnap = await FirebaseFirestore.instance
        .collection('event_feedback')
        .where('userId', isEqualTo: userId)
        .get();

    final List<Map<String, dynamic>> list = [];

    for (var doc in fbSnap.docs) {
      final data = doc.data();
      final eventDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(data['eventId'])
          .get();

      list.add({
        'eventTitle' : eventDoc.exists ? eventDoc['title'] : 'Unknown Event',
        'rating'     : data['rating'],
        'feedback'   : data['feedback'],
        'submittedAt': (data['submittedAt'] as Timestamp).toDate(),
      });
    }

    // newest first
    list.sort((a, b) => b['submittedAt'].compareTo(a['submittedAt']));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Feedback History'),
        backgroundColor: themeColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [themeColor, gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchMyFeedback(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            if (snap.hasError) {
              return Center(
                child: Text('❌ Error: ${snap.error}',
                    style: const TextStyle(color: Colors.white)),
              );
            }

            final feedbackList = snap.data ?? [];
            if (feedbackList.isEmpty) {
              return const Center(
                child: Text('📝 You haven’t submitted any feedback yet.',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: feedbackList.length,
              itemBuilder: (context, i) {
                final item = feedbackList[i];
                return Card(
                  color: Colors.white.withOpacity(0.95),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['eventTitle'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            5,
                            (idx) => Icon(Icons.star,
                                size: 20,
                                color: idx < item['rating']
                                    ? Colors.amber
                                    : Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(item['feedback']),
                        const SizedBox(height: 8),
                        Text(
                          'Submitted on: ${item['submittedAt'].toString().substring(0, 16)}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
