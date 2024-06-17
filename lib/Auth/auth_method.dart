import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to sign out the user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("User signed out");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  // Function to delete the user account
  Future<void> deleteUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        print("User account deleted");
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }
}
