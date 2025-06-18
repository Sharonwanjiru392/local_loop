import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VolunteerProfileScreen extends StatelessWidget {
  const VolunteerProfileScreen({super.key});

  // Deep purple theme colors
  static const Color themeColor = Color(0xFF5B2C6F); // Deep Purple
  static const Color gradientEnd = Color(0xFF9B59B6); // Lighter Purple

  Future<Map<String, dynamic>?> fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: themeColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [themeColor, gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: fetchProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            final data = snapshot.data;
            if (data == null) {
              return const Center(
                child: Text("No profile data found.", style: TextStyle(color: Colors.white)),
              );
            }

            return Center(
              child: Card(
                margin: const EdgeInsets.all(24),
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('👤 Name: ${data['name'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Text('📧 Email: ${data['email'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      if (data['contact'] != null)
                        Text('📱 Contact: ${data['contact']}',
                            style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      if (data['description'] != null)
                        Text('📝 Bio: ${data['description']}',
                            style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 20),
                      Text('⏱ Total Hours: ${data['totalHours'] ?? 0}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 20),
                      const Text('🎖️ Badges:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: [
                          if ((data['totalHours'] ?? 0) >= 1)
                            const Chip(label: Text('First Event')),
                          if ((data['totalHours'] ?? 0) >= 20)
                            const Chip(label: Text('20+ Hours')),
                          if ((data['totalHours'] ?? 0) >= 50)
                            const Chip(label: Text('50+ Hours')),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/volunteer/edit-profile');
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit Profile"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size.fromHeight(45),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
