// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/pages/home_page.dart';
import 'package:shop_app/pages/phonenumber_otp.dart';
import 'package:shop_app/pages/signup.dart';
import 'package:shop_app/service/auth.dart';
import 'package:shop_app/widgets/forgot_password.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";

  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = "";
        switch (e.code) {
          case 'user-not-found':
            message = "No User Found for that Email";
            break;
          case 'wrong-password':
            message = "Wrong Password Provided by User";
            break;
          case 'invalid-email':
            message = "Invalid Email Address";
            break;
          case 'user-disabled':
            message = "This account has been disabled";
            break;
          case 'too-many-requests':
            message = "Too many attempts. Try again later";
            break;
          case 'invalid-credential':
            message = "Invalid email or password";
            break;
          default:
            message = "Login failed. Please try again";
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "An unexpected error occurred",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    mailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0), // uniform horizontal padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 200, // limit image height
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/car.PNG",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 50),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30.0),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
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
                              return 'Please Enter E-mail';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
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
                      const SizedBox(height: 30.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 30.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFedf0f8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          controller: passwordcontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
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
                      const SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              email = mailcontroller.text.trim();
                              password = passwordcontroller.text;
                            });
                            userLogin();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF273671),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Color(0xFF8c8e98),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                const Text(
                  "or LogIn with",
                  style: TextStyle(
                    color: Color(0xFF273671),
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AuthMethods().signInWithGoogle(context);
                      },
                      child: Image.asset(
                        "assets/images/google.png",
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.login, size: 25),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    GestureDetector(
                      onTap: () {
                        AuthMethods().signInWithApple(context);
                      },
                      child: Image.asset(
                        "assets/images/apple1.png",
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.apple, size: 30),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PhoneNumber()),
                        );
                      },
                      

                      child: Image.asset(
                        "assets/images/phone.png",
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
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
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                        );
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                          color: Color(0xFF273671),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0), // Extra bottom spacing
              ],
            ),
          ),
        ));
  }
}
