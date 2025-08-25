import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/pages/signup.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Password Reset Email has been sent!",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "No user found for that email.",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background for whole page
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              "Password Recovery",
              style: TextStyle(
                color: Colors.black, // Black for contrast
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter your email",
              style: TextStyle(
                color: Colors.blue, // Blue stands out on white
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Form(
                key: _formkey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey, width: 1.5), // Grey border
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Email";
                            }
                            return null;
                          },
                          controller: mailcontroller,
                          style: const TextStyle(
                              color:
                                  Colors.black), // Black text for readability
                          decoration: const InputDecoration(
                            hintText: "Email",
                            hintStyle:
                                TextStyle(fontSize: 18, color: Colors.grey),
                            prefixIcon: Icon(Icons.email,
                                color: Colors.black54, size: 26),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              email = mailcontroller.text;
                            });
                            resetPassword();
                          }
                        },
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue, // Blue button for visibility
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Send Email",
                              style: TextStyle(
                                color: Colors.white, // White text on blue
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()),
                              );
                            },
                            child: const Text(
                              'Create',
                              style: TextStyle(
                                color: Colors.orange, // Orange for emphasis
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
