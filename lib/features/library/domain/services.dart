// lib/features/library/data/book_service.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class BookService {
  static final BookService _instance = BookService._internal();
  factory BookService() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // This will hold the globally accessible list of books
  List<Map<String, dynamic>> _fetchedBooks = [];

  BookService._internal();

  List<Map<String, dynamic>> get fetchedBooks => _fetchedBooks;

  Future<void> fetchUploadedFiles() async {
    try {
      var collection = await _firestore.collection('books').get();
      _fetchedBooks = collection.docs.map((doc) {
        var data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? 'No Name',
          'url': data['url'] ?? '',
        };
      }).toList();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error loading books: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      _fetchedBooks = []; // Return an empty list on error
    }
  }

  Future<void> uploadFile(File file, String customFileName, String currentUserId) async {
    if (customFileName.isEmpty) return;

    try {
      String fileName = file.path.split('/').last;
      var ref = _storage.ref().child('books/$fileName');
      await ref.putFile(file);
      String downloadUrl = await ref.getDownloadURL();

      await _firestore.collection('books').add({
        'name': customFileName,
        'url': downloadUrl,
      });

      // Fetch updated files after upload
      await fetchUploadedFiles();

      Fluttertoast.showToast(msg: "Uploaded successfully", backgroundColor: Colors.blue, textColor: Colors.white);
    } catch (e) {
      Fluttertoast.showToast(msg: "Upload failed: $e", backgroundColor: Colors.red, textColor: Colors.white);
    }
  }

  Future<void> deletePDF(String docId, String fileUrl) async {
    try {
      await _firestore.collection('books').doc(docId).delete();
      var storageRef = _storage.refFromURL(fileUrl);
      await storageRef.delete();

      // Fetch updated files after deletion
      await fetchUploadedFiles();

      Fluttertoast.showToast(
        msg: "Deleted successfully",
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to delete PDF: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
