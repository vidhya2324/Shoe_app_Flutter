import 'dart:typed_data'; // for web (bytes instead of File)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Dashboard extends StatefulWidget {
  final User? currentUser;
  const Dashboard({super.key, required this.currentUser});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String firstName = "";
  String lastName = "";
  String nickName = "";
  String dob = "";
  String gender = "";
  String bio = "";
  String imageUrl = "";
  int totalOrders = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (widget.currentUser == null) return;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      setState(() {
        firstName = snapshot["First Name"] ?? "";
        lastName = snapshot["Last Name"] ?? "";
        nickName = snapshot["Nick Name"] ?? "";
        dob = snapshot["Date of Birth"] ?? "";
        gender = snapshot["Gender"] ?? "";
        bio = snapshot["Bio about you"] ?? "";
        imageUrl = snapshot["ImageUrl"] ?? "";
        totalOrders = snapshot["TotalOrders"] ?? 0;
      });
    }
  }

  // 📌 Works on Web + Mobile
  Future<void> _pickAndUploadImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        Uint8List? fileBytes = result.files.first.bytes;
        String fileName = "${widget.currentUser!.uid}.jpg";

        // Upload to Firebase Storage
        Reference storageRef =
            FirebaseStorage.instance.ref().child("profilePics/$fileName");

        await storageRef.putData(fileBytes!);
        String downloadUrl = await storageRef.getDownloadURL();

        // Save URL in Firestore
        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.currentUser!.uid)
            .update({"ImageUrl": downloadUrl});

        setState(() {
          imageUrl = downloadUrl;
        });
      }
    } catch (e) {
      print("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2B3A),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Picture (clickable)
                  GestureDetector(
                    onTap: _pickAndUploadImage, // 📌 Web compatible
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : const NetworkImage("https://i.pravatar.cc/300"),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.camera_alt, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // User Name + Nickname
                  Text(
                    "$firstName $lastName",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nickName.isNotEmpty ? "($nickName)" : "",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stats Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat(dob.isNotEmpty ? dob : "--", "DOB"),
                      _buildStat(totalOrders.toString(), "Total Order"),
                      _buildStat(gender.isNotEmpty ? gender : "--", "Gender"),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Bio Section
                  if (bio.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        bio,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
