import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/pages/home_page.dart';
import 'package:shop_app/widgets/numericpad.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  TextEditingController _codecontroller = TextEditingController();
  String phoneNumber = "", data = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String smscode = "";

  _signinwithMobileNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91' + data.trim(),
        verificationCompleted: (PhoneAuthCredential authCredential) async {
          await _auth.signInWithCredential(authCredential).then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) =>  HomePage()));
          });
        },
        verificationFailed: (error) {
          print(error);
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text("Enter OTP"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: _codecontroller),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    final credential = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: _codecontroller.text,
                    );
                    _auth.signInWithCredential(credential).then((result) {
                      if (result != null) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) =>  HomePage()),
                        );
                      }
                    });
                  },
                  child: const Text("Done"),
                ),
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 45),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Continue with phone Number",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    // top section (image + message)
                    Container(
                      height: 260,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFFFFFF), Color(0xFFF7F7F7)],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 130,
                            child: Image.asset("assets/images/holdphone.png"),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "You will receive a 6 digit code to verify next.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF818181),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // phone input + button (centered & max-width)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 450),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  controller:
                                      TextEditingController(text: phoneNumber),
                                  cursorColor: Colors.black,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "0",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  data = phoneNumber;
                                  phoneNumber = "";
                                  setState(() {});
                                  _signinwithMobileNumber();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDC3D),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "Continue",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // numeric keypad
                    Numericpad(
                      onNumberSelected: (value) {
                        setState(() {
                          if (value != -1) {
                            phoneNumber = phoneNumber + value.toString();
                          } else {
                            phoneNumber = phoneNumber.substring(
                                0, phoneNumber.length - 1);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
