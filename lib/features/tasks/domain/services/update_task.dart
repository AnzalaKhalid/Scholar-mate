import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskUpdateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateTask(String taskId, String title, DateTime dateTime) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception("User is not logged in");
    }

    // Fetch the task document to verify the owner
    DocumentSnapshot taskDoc = await _firestore.collection('tasks').doc(taskId).get();

    if (taskDoc.exists && taskDoc['userId'] == userId) {
      // Only update if the task belongs to the logged-in user
      await _firestore.collection('tasks').doc(taskId).update({
        'Tasktitle': title,
        'dateTime': Timestamp.fromDate(dateTime),
      });
    } else {
      throw Exception("Unauthorized: Cannot update a task that does not belong to the user");
    }
  }
}
