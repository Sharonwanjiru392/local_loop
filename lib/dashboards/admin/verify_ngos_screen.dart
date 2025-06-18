import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyNgosScreen extends StatelessWidget {
  const VerifyNgosScreen({super.key});

  static const Color themeColor = Color(0xFF5B2C6F); // Deep purple

  Stream<QuerySnapshot> getPendingNgos() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'NGO')
        .where('isVerified', isEqualTo: false)
        .snapshots();
  }

  Future<void> approveNgo(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isVerified': true,
    });
  }

  Future<void> rejectNgo(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify NGOs'),
        backgroundColor: themeColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getPendingNgos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('❌ Failed to load NGOs'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                '🎉 No pending NGOs for verification.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final ngos = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ngos.length,
            itemBuilder: (context, index) {
              final ngo = ngos[index];
              final email = ngo['email'] ?? 'No email';
              final userId = ngo.id;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.how_to_reg_rounded, color: themeColor),
                  title: Text(email),
                  subtitle: const Text('NGO - Pending Verification'),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle_rounded, color: Colors.green),
                        onPressed: () => approveNgo(userId),
                        tooltip: 'Approve',
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel_rounded, color: Colors.red),
                        onPressed: () => rejectNgo(userId),
                        tooltip: 'Reject',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
