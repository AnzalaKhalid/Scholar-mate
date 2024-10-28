import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholar_mate/features/assignment/presentation/pages/assignment_screen.dart';
import 'package:scholar_mate/features/classroom/presentation/pages/classroom_screen.dart';
import 'package:scholar_mate/features/notes/presentation/Pages/note_screen.dart';
import 'package:scholar_mate/features/tasks/presentation/pages/task_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name = '';
  String _idNumber = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
Future<void> _fetchUserData() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the document for the current user
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Cast the document data to a Map
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      // Safely access the fields and update state with the user data
      if (userData != null) {
        setState(() {
          _name = userData['name'] ?? 'No name';  // Fallback if 'name' is not found
          _idNumber = userData['idNumber'] ?? 'No ID';  // Fallback if 'idNumber' is not found
        });
      } else {
        print('User document does not contain data');
      }
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Row
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _name.isNotEmpty ? _name : 'Loading...',  // Show loading if name not yet fetched
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _idNumber.isNotEmpty ? _idNumber : 'Loading...',  // Show loading if ID not yet fetched
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search courses, notes...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Access Cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCard('Class Rooms', Icons.class_, const Color(0xFF3A5A9F), const ClassroomScreen()),
                  _buildCard('Assignment', Icons.assignment, const Color(0xFF4CA1A3), const AssignmentScreen()),
                  _buildCard('Notes', Icons.note, const Color(0xFF8EA58A), const NotesListPage(userId: 'currentUserId')),
                  _buildCard('Task', Icons.task, const Color(0xFF6E7B8B), const TaskScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build each card
  Widget _buildCard(String title, IconData icon, Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
