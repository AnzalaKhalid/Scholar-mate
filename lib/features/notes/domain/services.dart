import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholar_mate/features/notes/data/models/note_model.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createNote(Note note) async {
    await _firestore.collection('notes').add(note.toMap());
  }

  Future<List<Note>> retrieveNotes(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .get();
    
    return snapshot.docs
        .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateNote(Note note) async {
    await _firestore.collection('notes').doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String noteId) async {
    await _firestore.collection('notes').doc(noteId).delete();
  }
}
