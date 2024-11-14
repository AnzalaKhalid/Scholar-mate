import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scholar_mate/features/notes/data/models/note_model.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createNote(Note note) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("User is not logged in. Unable to create note.");
    }

    // Add userId to the note data
    await _firestore.collection('notes').add({
      ...note.toMap(),
      'userId': userId,
    });
  }

  Future<List<Note>> retrieveNotes() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    QuerySnapshot snapshot = await _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateNote(Note note) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("User is not logged in. Unable to update note.");
    }

    // Ensure the note belongs to the logged-in user before updating
    DocumentSnapshot noteDoc = await _firestore.collection('notes').doc(note.id).get();
    if (noteDoc.exists && noteDoc['userId'] == userId) {
      await _firestore.collection('notes').doc(note.id).update(note.toMap());
    } else {
      throw Exception("Unauthorized: Cannot update a note that does not belong to the user");
    }
  }

  Future<void> deleteNote(String noteId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("User is not logged in. Unable to delete note.");
    }

    // Ensure the note belongs to the logged-in user before deleting
    DocumentSnapshot noteDoc = await _firestore.collection('notes').doc(noteId).get();
    if (noteDoc.exists && noteDoc['userId'] == userId) {
      await _firestore.collection('notes').doc(noteId).delete();
    } else {
      throw Exception("Unauthorized: Cannot delete a note that does not belong to the user");
    }
  }
}
