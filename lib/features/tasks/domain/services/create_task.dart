import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskAddService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createTask(String title, String description, DateTime dateTime) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("User is not logged in. Unable to add task.");
    }

    await _firestore.collection('tasks').add({
      'Tasktitle': title,
      'TaskDescription': description,
      'dateTime': Timestamp.fromDate(dateTime),
      'userId': userId,
    });
  }
}
