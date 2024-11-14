import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scholar_mate/features/notes/data/models/note_model.dart';
import 'package:scholar_mate/features/notes/domain/services.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key, required String userId});

  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final NotesService _notesService = NotesService();

  void _createNote() async {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Retrieve the logged-in user's ID
    if (userId == null) {
      // Handle case where user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in. Unable to create note.')),
      );
      return;
    }

    Note note = Note(
      title: _titleController.text,
      content: _contentController.text,
      userId: userId, // Use the retrieved user ID
    );

    await _notesService.createNote(note);
    Navigator.pop(context, true); // Return to previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createNote,
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
