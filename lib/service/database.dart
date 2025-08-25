import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUser(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("users") // 🔹 keep consistent collection name
        .doc(userId) // 🔹 use uid
        .set(userInfoMap);
  }

  Future addUserDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("users") // 🔹 same collection
        .doc() // 🔹 pass uid when calling
        .set(userInfoMap);
    // merge:true → so it won’t overwrite existing fields
  }
}
