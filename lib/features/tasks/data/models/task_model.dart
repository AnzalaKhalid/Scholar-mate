import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String tasktitle;
  String dateAndTime;

  Task({
    required this.id,
    required this.tasktitle,
    required this.dateAndTime,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      tasktitle: data['tasktitle'] ?? '',
      dateAndTime: data['dateAndTime'] ?? '',
    );
  }
}
