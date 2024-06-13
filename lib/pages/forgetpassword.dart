import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Password Reset Email Sent'),
          content: Text('Please check your email to reset your password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Navigate back to the login screen
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      String errorMessage = 'An error occurred';
      if (error is FirebaseAuthException) {
        // Handle FirebaseAuthException errors
        switch (error.code) {
          case 'invalid-email':
            errorMessage = 'Invalid email address';
            break;
          case 'user-not-found':
            errorMessage = 'User not found';
            break;
          // Add more cases for other possible error codes
          default:
            errorMessage = 'An error occurred';
        }
      } else {
        // Handle generic errors
        errorMessage = error.toString();
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Forgot Your Password?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Text(
              'Enter your email below to reset your Password.',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _resetPassword, child: Text("Reset Password"),
             
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ForgotPasswordPage(),
  ));
}
