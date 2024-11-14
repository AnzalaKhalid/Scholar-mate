import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scholar_mate/features/notes/data/models/note_model.dart';
import 'package:scholar_mate/features/notes/domain/services.dart';
import 'package:scholar_mate/features/notes/presentation/Pages/create_note.dart';
import 'package:scholar_mate/features/notes/presentation/Pages/noteDetail.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key, required String userId});

  @override
  _NotesListPageState createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  final NotesService _notesService = NotesService();
  List<Note> _notes = [];
  final String? userId = FirebaseAuth.instance.currentUser?.uid; // Retrieve the logged-in user ID

  @override
  void initState() {
    super.initState();
    _retrieveNotes();
  }

  Future<void> _retrieveNotes() async {
    if (userId == null) return; // Exit if no user is logged in

    try {
      List<Note> notes = await _notesService.retrieveNotes(); // Call without user ID
      setState(() {
        _notes = notes;
      });
    } catch (e) {
      // Handle error, e.g., show a SnackBar or a dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to retrieve notes: $e')),
      );
    }
  }

  void _navigateToCreateNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>const CreateNotePage(userId: '',)),
    ).then((value) {
      if (value == true) {
        _retrieveNotes(); // Refresh notes list if a note was created
      }
    });
  }

  void _navigateToDetail(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetailPage(note: note)),
    ).then((value) {
      if (value == true) {
        _retrieveNotes(); // Refresh notes list if a note was updated
      }
    });
  }

  void _confirmDelete(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Text('Confirm Deletion', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                await _notesService.deleteNote(note.id!); // Ensure id is not null
                Navigator.pop(context);
                _retrieveNotes(); // Refresh notes list after deletion
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToCreateNote,
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 219, 218, 218),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Standard padding
        child: ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            final note = _notes[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () => _navigateToDetail(note),
                child: Card(
                  color: Colors.blue,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    note.content,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(note),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
