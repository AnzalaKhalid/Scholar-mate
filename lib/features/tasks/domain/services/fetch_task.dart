import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TaskFetchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch tasks only for the logged-in user
  Future<List<Map<String, dynamic>>> retrieveTasks() async {
    final userId = _auth.currentUser?.uid; // Get the logged-in user's ID
    if (userId == null) return []; // Return empty list if user is not logged in

    final snapshot = await _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId) // Filter by user ID
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();

      // Format date and time if 'dateTime' exists
      if (data.containsKey('dateTime')) {
        Timestamp timestamp = data['dateTime'] as Timestamp;
        DateTime taskDateTime = timestamp.toDate();
        data['formattedDate'] = DateFormat('yyyy-MM-dd').format(taskDateTime);
        data['formattedTime'] = DateFormat('HH:mm a').format(taskDateTime);
      }

      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Delete a specific task from Firestore
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}
