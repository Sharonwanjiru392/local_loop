import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserRole(String userId, String newRole) async {
    await usersRef.doc(userId).update({'role': newRole});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Role updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  static const Color themeColor = Color(0xFF5B2C6F); // Deep purple

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: themeColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('❌ Error loading users'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user.id;
              final email = user['email'] ?? 'No email';
              final role = user['role'] ?? 'Unknown';

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.person_rounded, color: themeColor),
                  title: Text(email),
                  subtitle: Text('Role: $role'),
                  trailing: DropdownButton<String>(
                    value: role,
                    underline: Container(),
                    onChanged: (newRole) {
                      if (newRole != null && newRole != role) {
                        updateUserRole(userId, newRole);
                      }
                    },
                    items: ['Admin', 'NGO', 'Volunteer']
                        .map(
                          (r) => DropdownMenuItem(
                            value: r,
                            child: Text(r),
                          ),
                        )
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
