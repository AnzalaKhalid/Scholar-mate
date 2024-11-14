import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:scholar_mate/features/library/domain/services.dart';
import 'package:scholar_mate/features/library/presentation/pages/view_books.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  File? file;
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
    await _bookService.fetchUploadedFiles();
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
    await _bookService.uploadFile(file!, customFileName, customFileName);
    fetchUploadedFiles(); // Refresh the list after upload
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
            builder: (context) =>
                PDFViewPage(filePath: filePath, pdfName: pdfName),
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
    fetchUploadedFiles(); // Refresh the list after deletion
  }

  @override
  Widget build(BuildContext context) {
    // Fetch uploaded files from the global list
    List<Map<String, dynamic>> uploadedFiles = _bookService.fetchedBooks;

    // Use MediaQuery for responsive spacing and sizing
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 75),
                  child: Row(
                    children: [
                      Text(
                        "Library ",
                        style: TextStyle(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                     const Text(
                        ' (PDFs only)',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 1, 97, 205),
                ),
                SizedBox(height: screenHeight * 0.01),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth > 600
                          ? 3
                          : 2, // Adjusts for larger screens
                      childAspectRatio: screenWidth > 600 ? 0.7 : 0.75,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                    ),
                    itemCount: uploadedFiles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => openPDF(uploadedFiles[index]['url'],
                            uploadedFiles[index]['name']),
                        child: Card(
                          color: const Color.fromARGB(255, 5, 120, 251),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: screenWidth * 0.02,
                                left: screenHeight * 0.01,
                                right: screenHeight * 0.01),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: screenHeight * 0.2,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 1, 97, 205),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.white,
                                    size: 70,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        uploadedFiles[index]['name'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.04,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.white),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Delete PDF"),
                                            content: const Text(
                                                "Are you sure you want to delete this PDF?"),
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
                                                  deletePDF(
                                                      uploadedFiles[index]
                                                          ['id'],
                                                      uploadedFiles[index]
                                                          ['url']);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const Spacer(),
                              ],
                            ),
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
        backgroundColor: const Color.fromARGB(255, 1, 97, 205),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
