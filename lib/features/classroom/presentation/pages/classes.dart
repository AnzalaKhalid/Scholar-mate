import 'package:flutter/material.dart';

class ClassDetailsScreen extends StatelessWidget {
  final String className;
  final String classCode;

  const ClassDetailsScreen({
    super.key,
    required this.className,
    required this.classCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          className,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 97, 205),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Class Information Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Class Code: $classCode',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Class Description:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'This is a detailed description of the class. Here you can include various information such as the syllabus, important dates, and other relevant details.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Syllabus Card
              _buildCard('Syllabus', 'Overview of topics and evaluations.',
                  Icons.book, Colors.blueAccent),

              const SizedBox(height: 20),

              // Important Dates Card
              _buildCard(
                  'Important Dates',
                  'Midterm Exam, Assignment Due Dates, etc.',
                  Icons.calendar_today,
                  Colors.orange),

              const SizedBox(height: 20),

              // Assignments Card
              _buildCard(
                  'Assignments',
                  'Details about assignments and deadlines.',
                  Icons.assignment,
                  Colors.green),

              const SizedBox(height: 20),

              // Resources Card
              _buildCard('Resources', 'Links and materials for the class.',
                  Icons.link, Colors.purple),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      String title, String description, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
