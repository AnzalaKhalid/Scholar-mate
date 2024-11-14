import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Help & Support'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('FAQs'),
              _faqItem('What is this app about?', 'This app helps students manage their tasks and notes effectively.'),
              _faqItem('How to reset my password?', 'Go to settings and click on "Reset Password".'),
              
              _sectionTitle('Contact Information'),
              _contactItem(Icons.phone, '123-456-7890'),
              _contactItem(Icons.email, 'support@example.com'),
              
              _sectionTitle('Troubleshooting Guides'),
              _guideItem('Common Issues', 'Find solutions to common problems in this section.'),
              
              _sectionTitle('User Manuals'),
              _manualItem('User Guide', 'Download the complete user guide in PDF format.'),
              
              _sectionTitle('Feedback'),
              _feedbackSection(),
              
              _sectionTitle('Community Forum'),
              _forumLink('Join our Community Forum'),
              
              _sectionTitle('Updates & Announcements'),
              _updateItem('Version 1.0 Released', 'Check out the new features and improvements.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }

  Widget _faqItem(String question, String answer) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(question),
        subtitle: Text(answer),
      ),
    );
  }

  Widget _contactItem(IconData icon, String info) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(info),
    );
  }

  Widget _guideItem(String title, String description) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      trailing:const Icon(Icons.arrow_forward, color: Colors.blueAccent),
      onTap: () {
        // Navigate to troubleshooting guide
      },
    );
  }

  Widget _manualItem(String title, String description) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      trailing:const Icon(Icons.download, color: Colors.blueAccent),
      onTap: () {
        // Download user manual
      },
    );
  }

  Widget _feedbackSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title:const Text('Send us your feedback'),
        trailing:const Icon(Icons.arrow_forward, color: Colors.blueAccent),
        onTap: () {
          // Navigate to feedback form
        },
      ),
    );
  }

  Widget _forumLink(String title) {
    return ListTile(
      title: Text(title, style:const TextStyle(color: Colors.blueAccent)),
      onTap: () {
        // Navigate to community forum
      },
    );
  }

  Widget _updateItem(String title, String description) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      trailing:const Icon(Icons.info, color: Colors.blueAccent),
      onTap: () {
        // Show update details
      },
    );
  }
}

