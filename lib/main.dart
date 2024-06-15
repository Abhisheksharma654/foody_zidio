import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:foody_zidio/pages/onboard.dart';
import 'package:foody_zidio/pages/signup.dart';
import 'package:foody_zidio/service/app_constraint.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishableKey;
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
         
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foody',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Onboard(),
    );
  }
}
