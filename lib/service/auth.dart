import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_app/pages/home_page.dart';
import 'package:shop_app/service/database.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return; // user canceled sign-in
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result = await auth.signInWithCredential(credential);
      User? userDetails = result.user;

      if (userDetails != null) {
        Map<String, dynamic> userInfoMap = {
          "email": userDetails.email,
          "name": userDetails.displayName,
          "imgUrl": userDetails.photoURL,
          "id": userDetails.uid,
        };

        await DatabaseMethods().addUser(userDetails.uid, userInfoMap);

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  HomePage()),
          );
        }
      }
    } catch (e) {
      print("Google sign-in failed: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign in failed: $e")),
        );
      }
    }
  }

  Future<User?> signInWithApple(BuildContext context) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final UserCredential result =
          await auth.signInWithCredential(oauthCredential);
      final User? userDetails = result.user;

      if (userDetails != null) {
        // Update display name if available from Apple ID
        String? displayName;
        if (credential.givenName != null && credential.familyName != null) {
          displayName = '${credential.givenName} ${credential.familyName}';
          await userDetails.updateDisplayName(displayName);
        }

        Map<String, dynamic> userInfoMap = {
          "email": userDetails.email ?? credential.email,
          "name": displayName ?? userDetails.displayName,
          "imgUrl": userDetails.photoURL,
          "id": userDetails.uid,
        };

        await DatabaseMethods().addUser(userDetails.uid, userInfoMap);

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  HomePage()),
          );
        }

        return userDetails;
      }
    } catch (e) {
      print("Apple sign-in failed: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Apple sign in failed: $e")),
        );
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }
}
