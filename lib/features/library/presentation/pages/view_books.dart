import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scholar_mate/mainPage/navigation.dart';

class PDFViewPage extends StatefulWidget {
  final String filePath;
  final String pdfName;

  const PDFViewPage({super.key, required this.filePath, required this.pdfName});

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  int totalPages = 0;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pdfName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Navigation()));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 4,
      ),
      body: Container(
        color: const Color(0xFFE3F2FD),
        child: Column(
          children: [
            Expanded(
              child: PDFView(
                filePath: widget.filePath,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: true, // Enable page fling for smoother navigation
                fitEachPage: true, // Make sure each page fits in the view
                onError: (error) {
                  Fluttertoast.showToast(
                    msg: "Error loading PDF: $error",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                },
                onRender: (pages) {
                  setState(() {
                    totalPages = pages!;
                    currentPage = 1; // Start on the first page
                  });
                  Fluttertoast.showToast(
                    msg: "PDF loaded: $pages pages",
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                  );
                },
                onPageChanged: (page, total) {
                  setState(() {
                    currentPage = page!; // Update the current page
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Page $currentPage of $totalPages',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Fluttertoast.showToast(
            msg: "Floating Action Button Pressed",
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        },
        tooltip: 'Options',
        backgroundColor: const Color(0xFF1E88E5),
        child: const Icon(Icons.more_horiz, color: Colors.white),
      ),
    );
  }
}
