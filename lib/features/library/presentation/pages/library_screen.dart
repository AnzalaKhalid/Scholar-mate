// lib/features/library/presentation/pages/library_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:scholar_mate/features/library/domain/services.dart';
import 'package:scholar_mate/features/library/presentation/pages/view_books.dart'; // Adjust as necessary

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  File? file;
  List<Map<String, dynamic>> uploadedFiles = [];
  bool isLoading = false;
  final BookService _bookService = BookService();

  @override
  void initState() {
    super.initState();
    fetchUploadedFiles();
  }

  Future<void> fetchUploadedFiles() async {
    setState(() {
      isLoading = true;
    });
    uploadedFiles = await _bookService.fetchUploadedFiles();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });
      showNameInputDialog();
    }
  }

  Future<void> uploadFile(String customFileName) async {
    if (file == null || customFileName.isEmpty) return;
    await _bookService.uploadFile(file!, customFileName);
    fetchUploadedFiles();
  }

  Future<void> showNameInputDialog() async {
    String customFileName = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter PDF Name"),
          content: TextField(
            onChanged: (value) {
              customFileName = value;
            },
            decoration: const InputDecoration(hintText: "Enter a custom name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Upload"),
              onPressed: () {
                Navigator.of(context).pop();
                uploadFile(customFileName);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> openPDF(String url, String pdfName) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        final filePath = '${dir.path}/${url.split('/').last}';
        final pdfFile = File(filePath);
        await pdfFile.writeAsBytes(bytes);

        setState(() {
          isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewPage(filePath: filePath, pdfName: pdfName),
          ),
        );
      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Failed to open PDF: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> deletePDF(String docId, String fileUrl) async {
    await _bookService.deletePDF(docId, fileUrl);
    fetchUploadedFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 218, 218),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Uploaded Books:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text("PDF only"),
                Expanded(
                  child: ListView.builder(
                    itemCount: uploadedFiles.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color(0xFF457b9d), 
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            uploadedFiles[index]['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          subtitle: const Text(
                            "Tap to view",
                            style: TextStyle(color: Colors.black54),
                          ),
                          onTap: () => openPDF(uploadedFiles[index]['url'], uploadedFiles[index]['name']),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete PDF"),
                                  content: const Text("Are you sure you want to delete this PDF?"),
                                  actions: [
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Delete"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        deletePDF(uploadedFiles[index]['id'], uploadedFiles[index]['url']);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFile,
        tooltip: 'Upload PDF',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
