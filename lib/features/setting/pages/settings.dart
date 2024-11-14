import 'package:flutter/material.dart';
import 'package:scholar_mate/features/setting/pages/about.dart';
import 'package:scholar_mate/features/setting/pages/helpAndSupport.dart';
import 'package:scholar_mate/features/setting/pages/privacy.dart';
import 'package:scholar_mate/mainPage/navigation.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationsEnabled = true; // Initial state of the switch

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light background color
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:const Color.fromARGB(255, 1, 97, 205),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>const Navigation()));
          },
          icon:const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile section
          ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.blueAccent),
            title: const Text("Profile"),
            subtitle: const Text("View and edit your profile details"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Profile Page
            },
          ),
          const Divider(),

          // Notification settings
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blueAccent),
            title: const Text("Notifications"),
            subtitle: const Text("Manage notification settings"),
            trailing: Switch(
              value: isNotificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  isNotificationsEnabled = value; // Update the state
                });
              },
            ),
          ),
          const Divider(),

          // Privacy settings
          GestureDetector(
            onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const PrivacyPolicyPage()));
              },
            child:const ListTile(
              leading:  Icon(Icons.lock, color: Colors.blueAccent),
              title:  Text("Privacy"),
              subtitle:  Text("Manage your privacy settings"),
              trailing:  Icon(Icons.arrow_forward_ios),
              
            ),
          ),
          const Divider(),

          // Help & Support
          GestureDetector(
            onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const HelpAndSupportPage()));
              },
            child:const ListTile(
              leading:  Icon(Icons.help, color: Colors.blueAccent),
              title:  Text("Help & Support"),
              subtitle:  Text("Get help and support"),
              trailing:  Icon(Icons.arrow_forward_ios),
              
            ),
          ),
          const Divider(),

          // About
          GestureDetector(
            child: ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AboutPage()));
              },
              leading: const Icon(Icons.info, color: Colors.blueAccent),
              title: const Text("About"),
              subtitle: const Text("Learn more about the app"),
              trailing: const Icon(Icons.arrow_forward_ios),
              
            ),
          ),
          const Divider(),

          // Logout button
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Implement logout functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }
}
