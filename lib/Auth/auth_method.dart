import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw e; // Optionally rethrow the error to handle it in UI or other parts of the code
    }
  }

  Future<void> deleteUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      } else {
        throw Exception('No user found to delete');
      }
    } catch (e) {
      print('Error deleting user: $e');
      throw e; // Optionally rethrow the error to handle it in UI or other parts of the code
    }
  }
}
