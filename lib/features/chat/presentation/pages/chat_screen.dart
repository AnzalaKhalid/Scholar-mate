import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scholar_mate/features/chat/presentation/pages/contact_page.dart';
import 'package:scholar_mate/features/chat/presentation/pages/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _filteredUsers = [];
  String? _currentUserDepartment;
  String? _currentUserSemester;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserDetails();
  }

  Future<void> _fetchCurrentUserDetails() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _currentUserId = currentUser.uid;
      final userDoc =
          await _firestore.collection('users').doc(_currentUserId).get();
      _currentUserDepartment = userDoc['department'];
      _currentUserSemester = userDoc['semester'];
      _fetchFilteredUsers();
    }
  }

  Future<void> _fetchFilteredUsers() async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('department', isEqualTo: _currentUserDepartment)
        .where('semester', isEqualTo: _currentUserSemester)
        .get();

    setState(() {
      _filteredUsers = querySnapshot.docs
          .where((doc) => doc.id != _currentUserId) // Exclude current user
          .map((doc) => doc.data())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _filteredUsers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      // Navigate to user profile page when profile picture is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserProfilePage(userId: user['userId']),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: user['profileImageUrl'] != null &&
                              user['profileImageUrl'].isNotEmpty
                          ? CachedNetworkImageProvider(user['profileImageUrl'])
                          : const AssetImage(
                                  'assets/images/default_profile.png')
                              as ImageProvider,
                      // Optionally add a placeholder and error handling
                      child: user['profileImageUrl'] == null ||
                              user['profileImageUrl'].isEmpty
                          ? Icon(Icons.person,
                              color:
                                  Colors.grey[600]) // Default icon if no image
                          : null,
                    ),
                  ),
                  title: Text(
                    user['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("Department of ${user['department']}"),
                  onTap: () {
                    // Navigate to chat screen with the selected user
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                            contactId: user['userId']), // Pass the user's ID
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
