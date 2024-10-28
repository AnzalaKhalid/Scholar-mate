import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDeleteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to delete a specific task by its ID
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}
