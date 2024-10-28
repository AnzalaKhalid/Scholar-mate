import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskaddService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addTask(String title, String description, DateTime dateTime) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return; // Ensure the user is logged in

    await _firestore.collection('tasks').add({
      'Tasktitle': title,
      'TaskDescription': description,
      'dateTime': Timestamp.fromDate(dateTime),
      'userId': userId, // Associate task with the user
    });
  }
}
