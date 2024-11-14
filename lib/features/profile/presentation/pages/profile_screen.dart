import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholar_mate/features/authentications/presentation/pages/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User profile information
  String _name = '';
  String _fatherName = '';
  String _department = '';
  String _idNumber = '';
  String _semester = '';
  String _profileImageUrl = '';
  bool _isLoading = true;

  final ImagePicker _picker = ImagePicker();

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?;
          setState(() {
            _name = userData?['name'] ?? 'N/A';
            _fatherName = userData?['fatherName'] ?? 'N/A';
            _department = userData?['department'] ?? 'N/A';
            _idNumber = userData?['idNumber'] ?? 'N/A';
            _semester = userData?['semester'] ?? 'N/A';
            _profileImageUrl = userData?['profileImageUrl'] ?? '';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching user data: $e');
    }
  }

  // Select and upload a profile image
  Future<void> _uploadProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String filePath =
            'profile_pictures/${FirebaseAuth.instance.currentUser!.uid}.png';
        File file = File(image.path); // Use the original image path
        await FirebaseStorage.instance.ref(filePath).putFile(file);
        String downloadUrl =
            await FirebaseStorage.instance.ref(filePath).getDownloadURL();
        await _updateUserProfileImage(downloadUrl);
      }
    } catch (e) {
      print('Error uploading profile image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  // Update the profile image URL in Firestore
  Future<void> _updateUserProfileImage(String url) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profileImageUrl': url});
      setState(() {
        _profileImageUrl = url;
      });
    }
  }

  // Delete the profile image from Firebase Storage and Firestore
  Future<void> _deleteProfileImage() async {
    try {
      String filePath =
          'profile_pictures/${FirebaseAuth.instance.currentUser!.uid}.png';
      await FirebaseStorage.instance.ref(filePath).delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'profileImageUrl': FieldValue.delete(),
      });

      setState(() {
        _profileImageUrl = '';
      });

      Navigator.pop(context);
    } catch (e) {
      print('Error deleting profile image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete image: $e')),
      );
    }
  }

  // Sign out the user
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfilePicture(),
                    const SizedBox(height: 20),
                    _buildUserInfo(),
                    const SizedBox(height: 30),
                    _buildProfileDetails(),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _signOut,
        child: const Icon(Icons.logout),
      ),
    );
  }

  // Profile Picture with Edit and Fullscreen View
  Widget _buildProfilePicture() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: () {
            if (_profileImageUrl.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(
                    imageUrl: _profileImageUrl,
                    onDelete: _deleteProfileImage,
                  ),
                ),
              );
            }
          },
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            backgroundImage: _profileImageUrl.isNotEmpty
                ? NetworkImage(_profileImageUrl)
                : null,
            child: _profileImageUrl.isEmpty
                ? const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: InkWell(
            onTap: _uploadProfileImage,
            child: const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.teal,
              child: Icon(
                Icons.edit,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // User Info Display
  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          _name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          _fatherName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'ID: $_idNumber',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // Detailed Profile Information
  Widget _buildProfileDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileDetail(_department, Icons.school, 'Department'),
          const Divider(),
          _buildProfileDetail(
              '$_semester th Semester', Icons.assignment, 'Semester'),
        ],
      ),
    );
  }

  // Single Profile Detail Row
  Widget _buildProfileDetail(String value, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Full-Screen Image View with Delete Option
class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDelete;

  const FullScreenImage(
      {super.key, required this.imageUrl, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
