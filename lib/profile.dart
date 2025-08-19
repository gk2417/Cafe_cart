import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:flutter_application_1/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
  
}
Future<void> logout(BuildContext context) async {
  // Sign out from Firebase Auth
  await FirebaseAuth.instance.signOut();

  // Clear saved email from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_email');

  // Optional: Clear global variable
  globals.loggedInEmail = "";

  // Navigate back to LoginPage
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => LoginPage()),
    (route) => false,
  );
}

class _ProfileState extends State<Profile> {
  File? _profileImage;
  
  String _userName = "Gokul Kumar";
   String _userEmail = globals.loggedInEmail;
  @override
  void initState() {
    super.initState();
    _loadImageFromPrefs();
    _loadUserInfo();
  }

  // Load image from SharedPreferences
  Future<void> _loadImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image_path');
    

    

    if (path != null && File(path).existsSync()) {
      setState(() {
        _profileImage = File(path);
        
        _userName = prefs.getString('UserName') ?? "Not Found";
      });
    }
  }

  // Pick image and save it locally
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final directory = await getApplicationDocumentsDirectory();
      final filename = basename(pickedImage.path);
      final savedImage =
          await File(pickedImage.path).copy('${directory.path}/$filename');

      setState(() {
        _profileImage = savedImage;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', savedImage.path);
    }
  }

  // Load name and email
  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? _userName;
      _userEmail = prefs.getString('user_email') ?? _userEmail;
    });
  }

  // Save name and email
  Future<void> _saveUserInfo(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:
            const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userName = nameController.text;
                _userEmail = emailController.text;
              });
              _saveUserInfo(_userName, _userEmail);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/item2.jpg')
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.brown,
                        child: const Icon(Icons.edit, size: 18, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _userName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              _userEmail,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  profileTile(Icons.person, "Edit Profile", () {
                    _showEditProfileDialog(context);
                  }),
                  profileTile(Icons.lock, "Change Password", () {}),
                  profileTile(Icons.history, "Order History", () {}),
                  profileTile(Icons.settings, "Settings", () {}),
                  profileTile(Icons.logout, "Logout", () {
                    logout(context);
                  }),
                ],
              ),
            )
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 253, 235, 229),
    );
  }

  Widget profileTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: const Color.fromARGB(255, 253, 205, 188),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
