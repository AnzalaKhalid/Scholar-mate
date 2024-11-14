// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Loginfirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(uid).set(userData);
  }
}
