import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageVolunteersScreen extends StatelessWidget {
  const ManageVolunteersScreen({super.key});

  // Updated to match AdminDashboard theme
  static const Color themeColor = Color(0xFF5B2C6F); // Deep Purple

  Future<void> _updateRole(String docId, String newRole, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('volunteers').doc(docId).update({
        'role': newRole,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Role updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to update role: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Volunteers'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('volunteers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: themeColor),
            );
          }

          final volunteers = snapshot.data!.docs;

          if (volunteers.isEmpty) {
            return const Center(child: Text('No volunteers found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: volunteers.length,
            itemBuilder: (context, index) {
              final data = volunteers[index].data() as Map<String, dynamic>;
              final docId = volunteers[index].id;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(data['name'] ?? 'No Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['email'] ?? ''),
                      const SizedBox(height: 4),
                      Text('Role: ${data['role'] ?? 'N/A'}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.edit),
                    onSelected: (role) => _updateRole(docId, role, context),
                    itemBuilder: (_) => ['Participant', 'Team Leader', 'Coordinator']
                        .map((role) => PopupMenuItem(value: role, child: Text(role)))
                        .toList(),
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
