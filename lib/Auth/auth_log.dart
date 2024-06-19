import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foody_zidio/Content/bottom_nav.dart';
import 'package:foody_zidio/Content/onboard.dart'; // Import your regular user page

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> performUserAction(BuildContext context, String action) async {
  try {
    if (action == 'signOut') {
      await _auth.signOut();
      print("User signed out");
    } else if (action == 'deleteUser') {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        print("User account deleted");
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Onboard()), // Navigate to BottomNav
    );
  } catch (e) {
    print("Error performing user action: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Error: $e",
        style: TextStyle(fontSize: 18.0, color: Colors.black),
      ),
    ));
  }
}