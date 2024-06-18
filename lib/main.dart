import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foody_zidio/Admin/admin.dart';
import 'package:foody_zidio/Content/bottom_nav.dart';
import 'package:foody_zidio/Content/onboard.dart';
import 'package:foody_zidio/pages/login.dart';
import 'package:foody_zidio/service/app_constraint.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishableKey;
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkUserStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          bool isLoggedIn = snapshot.data?[0] as bool;
          //  bool hasCompletedOnboarding = snapshot.data?[1] as bool;

          if (isLoggedIn) {
            return BottomNav();
          } /* else if (hasCompletedOnboarding) {
            return LogIn();
          }*/
          else {
            return AdminLogin();
          }
        }
      },
    );
  }

  Future<List<bool>> _checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasCompletedOnboarding = prefs.getBool('onboardingComplete') ?? false;
    User? user = FirebaseAuth.instance.currentUser;
    bool isLoggedIn = user != null;
    return [isLoggedIn, hasCompletedOnboarding];
  }
}
