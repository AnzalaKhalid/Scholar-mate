import 'package:flutter/material.dart';
import 'package:scholar_mate/features/classroom/presentation/pages/classes.dart';
import 'package:scholar_mate/mainPage/navigation.dart';

class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  // Sample class data
  final List<Map<String, String>> classes = [
    {'name': 'Mathematics', 'code': 'MATH101'},
    {'name': 'Computer Science', 'code': 'CS102'},
    {'name': 'Physics', 'code': 'PHY103'},
    // Add more classes as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Classroom",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 97, 205),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Navigation()));
          },
        ),
      ),
      body: Container(
        color: const Color(0xFFEFEFEF), // Light gray background
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: classes.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 8, // Increased elevation for a bolder shadow
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // More rounded corners
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  classes[index]['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // Increased font size
                    color: Color.fromARGB(255, 0, 51, 102), // Darker text color
                  ),
                ),
                subtitle: Text(
                  'Class Code: ${classes[index]['code']}',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54), // Softer subtitle color
                ),
                trailing: const Icon(Icons.chevron_right,
                    color: Colors.blue), // Customized icon color
                onTap: () {
                  // Navigate to class details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassDetailsScreen(
                        className: classes[index]['name']!,
                        classCode: classes[index]['code']!,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement functionality to add a new class
        },
        backgroundColor:
            const Color.fromARGB(255, 1, 97, 205), // Match app bar color
        child: const Icon(Icons.add),
      ),
    );
  }
}
