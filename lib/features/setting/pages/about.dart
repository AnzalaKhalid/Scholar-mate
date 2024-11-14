import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: const Color.fromARGB(255, 1, 97, 205),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App logo and title
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 1, 97, 205),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/logo1.png',
                          height: 60,
                          width: 60,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Scholar Mate",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 1, 97, 205),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // App Overview
              const Text(
                "Overview",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Scholar Mate is a comprehensive student assistant designed to help students manage tasks, notes, assignments, and collaborate with classmates and instructors. With a focus on simplicity and efficiency, Scholar Mate provides the tools students need to stay organized and succeed academically.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              
              const SizedBox(height: 30),
              
              // Features Section
              const Text(
                "Key Features",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              const ListTile(
                leading: Icon(Icons.task_alt, color: Colors.blueAccent),
                title: Text("Task Management"),
                subtitle: Text("Organize your tasks and track progress"),
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.notes, color: Colors.blueAccent),
                title: Text("Note-taking"),
                subtitle: Text("Easily add and access notes for quick reference"),
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.class_, color: Colors.blueAccent),
                title: Text("Classroom & Assignments"),
                subtitle: Text("Stay up-to-date with class materials and assignments"),
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.chat, color: Colors.blueAccent),
                title: Text("AI-powered Chat Assistant"),
                subtitle: Text("Interact with an AI assistant for quick help"),
              ),
              const Divider(),

              const SizedBox(height: 30),

              // Developer Info
              const Text(
                "About the Developer",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Scholar Mate was developed by a dedicated team passionate about improving student life. With a commitment to helping students succeed, we’ve created this app to be a trusted companion throughout your academic journey.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

              const SizedBox(height: 30),

              // Contact Information
              const Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.email, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text("scholarmate4@gmail.com", style: TextStyle(fontSize: 16, color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.language, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text("www.scholarmate.com", style: TextStyle(fontSize: 16, color: Colors.black54)),
                ],
              ),

              const SizedBox(height: 30),

              // Version and Acknowledgments
              const Text(
                "App Version",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Scholar Mate v1.0.0",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              
              const SizedBox(height: 30),
              
              // Acknowledgments Section
              const Text(
                "Acknowledgments",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "We would like to thank Flutter, Firebase, and all contributors who helped make Scholar Mate possible.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
