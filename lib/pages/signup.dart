import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_app/pages/home_page.dart';
import 'package:shop_app/pages/login_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shop_app/pages/phonenumber_otp.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password.isNotEmpty &&
        namecontroller.text.isNotEmpty &&
        mailcontroller.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Registered Successfully",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          String message = "";
          if (e.code == 'weak-password') {
            message = "Password Provided is too Weak";
          } else if (e.code == "email-already-in-use") {
            message = "Account Already exists";
          } else {
            message = "Registration failed. Please try again.";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                message,
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    namecontroller.dispose();
    passwordcontroller.dispose();
    mailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const SizedBox(height: 10.0),

          // Car Image
          Container(
            height: 200,
            width: double.infinity,
            child: Image.asset("images/car.PNG", fit: BoxFit.cover),
          ),
          const SizedBox(height: 15.0),

          // Form
          Form(
            key: _formkey,
            child: Column(
              children: [
                // Name field
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 30.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFedf0f8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                    controller: namecontroller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Name",
                      hintStyle: TextStyle(
                        color: Color(0xFFb2b7bf),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),

                // Email field
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 30.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFedf0f8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please Enter Valid Email';
                      }
                      return null;
                    },
                    controller: mailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                      hintStyle: TextStyle(
                        color: Color(0xFFb2b7bf),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),

                // Password field
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 30.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFedf0f8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    controller: passwordcontroller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: Color(0xFFb2b7bf),
                        fontSize: 18.0,
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20.0),

                // Sign Up button with pointer cursor
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          email = mailcontroller.text;
                          name = namecontroller.text;
                          password = passwordcontroller.text;
                        });
                        registration();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF273671),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),

          const Text(
            "or LogIn with",
            style: TextStyle(
              color: Color(0xFF273671),
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15.0),

          // Social login buttons with pointer cursor and onTap
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      if (kIsWeb) {
                        // Web Google Sign-In
                        GoogleAuthProvider googleProvider =
                            GoogleAuthProvider();
                        await FirebaseAuth.instance
                            .signInWithPopup(googleProvider);
                      } else {
                        // Mobile Google Sign-In
                        final GoogleSignIn googleSignIn = GoogleSignIn();
                        final GoogleSignInAccount? googleUser =
                            await googleSignIn.signIn();
                        if (googleUser == null) return; // user canceled

                        final GoogleSignInAuthentication googleAuth =
                            await googleUser.authentication;
                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );

                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                      }

                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }
                    } catch (e) {
                      print("Google Sign-In failed: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Google Sign-In failed")),
                      );
                    }
                  },
                  child: Image.asset(
                    "images/google.png",
                    height: 45,
                    width: 45,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 30.0),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Add Apple Sign-In logic here
                    print("Apple Sign-In tapped");
                  },
                  child: Image.asset(
                    "images/apple1.png",
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 30.0),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PhoneNumber()),
                    );
                  },
                  child: Image.asset(
                    "images/phone.png",
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(height: 20.0),

          // Login redirect
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account?",
                style: TextStyle(
                  color: Color(0xFF8c8e98),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 5.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogIn()),
                  );
                },
                child: const Text(
                  "LogIn",
                  style: TextStyle(
                    color: Color(0xFF273671),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
