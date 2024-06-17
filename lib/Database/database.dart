import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    try {
      await _firestore.collection('users').doc(id).set(userInfoMap);
      print('User added to Firestore with ID: $id');
    } catch (e) {
      print('Error adding user to Firestore: $e');
      // Handle error as needed
    }
  }

  Future<void> updateUserWallet(String id, String amount) async {
    try {
      await _firestore.collection("users").doc(id).update({"Wallet": amount});
      print('Wallet updated for user ID: $id');
    } catch (e) {
      print('Error updating wallet: $e');
      // Handle error as needed
    }
  }
}
