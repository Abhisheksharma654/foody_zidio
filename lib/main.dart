import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:foody_zidio/pages/onboard.dart';
import 'package:foody_zidio/pages/signup.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
