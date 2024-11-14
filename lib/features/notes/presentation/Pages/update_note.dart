import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scholar_mate/features/notes/data/models/note_model.dart';
import 'package:scholar_mate/features/notes/domain/services.dart';

class NoteUpdatePage extends StatefulWidget {
  final Note note;

  const NoteUpdatePage({super.key, required this.note});

  @override
  _NoteUpdatePageState createState() => _NoteUpdatePageState();
}

class _NoteUpdatePageState extends State<NoteUpdatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final NotesService _notesService = NotesService();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the current note's details
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;
  }

  void _updateNote() async {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID

    if (userId == null) {
      // Handle case where user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in. Unable to update note.')),
      );
      return;
    }

    // Create an updated note object
    Note updatedNote = Note(
      id: widget.note.id, // Existing note ID for updating
      title: _titleController.text,
      content: _contentController.text,
      userId: userId, // Use the retrieved user ID
    );

    // Call the update method in the notes service
    await _notesService.updateNote(updatedNote);
    
    // Pop the current page and return to the previous one with an indication that the note was updated
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Note"),
        centerTitle: true, // Center the title
        elevation: 0, // Remove the shadow for a cleaner look
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Enable scrolling for long content
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    ),
                    maxLines: 5,
                    minLines: 3,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateNote, // Trigger the update when the button is pressed
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(double.infinity, 0), // Make the button fill the width
                    ),
                    child: const Text(
                      'Update Note',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
