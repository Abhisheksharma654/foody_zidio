import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getcurrentUser() async {
    return await auth.currentUser;
  }

  Future signout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future deleteUser() async {
    User? user = await FirebaseAuth.instance.currentUser ;
    if (user != null) {
      await user.delete();
      print("User account deleted");
    }
  }
}
