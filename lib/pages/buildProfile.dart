import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BuildProfilePage extends StatefulWidget {
  final User? currentUser;
  const BuildProfilePage({super.key, required this.currentUser});

  @override
  State<BuildProfilePage> createState() => _BuildProfilePageState();
}

class _BuildProfilePageState extends State<BuildProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.deepPurple.shade50, // background color
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // 🔑 Form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name Input
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Enter your full name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required"; // ❌ Validation
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nickname Input
              TextFormField(
                controller: nicknameController,
                decoration: const InputDecoration(
                  labelText: "Nickname",
                  hintText: "Enter your nickname",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nickname is required"; // ❌ Validation
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Create Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // ✅ Only runs if form is valid
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile Created Successfully!")),
                    );

                    // Navigate to Profile Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          name: nameController.text,
                          nickname: nicknameController.text,
                        ),
                      ),
                    );
                  }
                },
                child: const Text("Create",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String name;
  final String nickname;

  const ProfilePage({super.key, required this.name, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.deepPurple.shade50, // background color
        child: Center(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      name[0].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(name,
                      style:
                          const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("($nickname)",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
