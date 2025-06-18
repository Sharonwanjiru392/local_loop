import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Updated deep purple theme
  static const Color themeColor = Color(0xFF5B2C6F);
  static const Color gradientEnd = Color(0xFF9B59B6);

  final TextEditingController feedbackController = TextEditingController();
  String? selectedEventId;
  int selectedRating = 0;

  Future<List<Map<String, String>>> fetchAttendedEvents() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in");

    final snapshot = await FirebaseFirestore.instance
        .collection('event_registrations')
        .where('userId', isEqualTo: userId)
        .get();

    List<Map<String, String>> eventList = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final eventId = data['eventId'];
      if (eventId != null) {
        final eventSnapshot = await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .get();
        final title = eventSnapshot.data()?['title'] ?? 'Unnamed Event';
        eventList.add({'eventId': eventId, 'title': title});
      }
    }

    return eventList;
  }

  Future<void> submitFeedback() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (selectedEventId == null || selectedRating == 0 || feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❗ Please fill in all fields.')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('event_feedback').add({
      'eventId': selectedEventId,
      'userId': userId,
      'rating': selectedRating,
      'feedback': feedbackController.text.trim(),
      'submittedAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Feedback submitted!')),
    );

    setState(() {
      selectedRating = 0;
      selectedEventId = null;
      feedbackController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Feedback'),
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
        child: FutureBuilder<List<Map<String, String>>>(
          future: fetchAttendedEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            if (snapshot.hasError) {
              return Center(child: Text('❌ Error: ${snapshot.error}'));
            }

            final events = snapshot.data ?? [];

            if (events.isEmpty) {
              return const Center(
                child: Text(
                  '⚠️ You have no attended events.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: (events.any((event) => event['eventId'] == selectedEventId))
                        ? selectedEventId
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Select Event',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    items: events.map((event) {
                      return DropdownMenuItem<String>(
                        value: event['eventId'],
                        child: Text(event['title'] ?? 'Unknown'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedEventId = val),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: i < selectedRating ? Colors.amber : Colors.grey,
                        ),
                        onPressed: () => setState(() => selectedRating = i + 1),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: feedbackController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Your feedback',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: submitFeedback,
                    icon: const Icon(Icons.send),
                    label: const Text('Submit Feedback'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      minimumSize: const Size.fromHeight(45),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
