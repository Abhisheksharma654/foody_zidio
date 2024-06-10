import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foody_zidio/pages/home.dart';
import 'package:foody_zidio/pages/login.dart';
import 'package:foody_zidio/pages/onboard.dart';
import 'package:foody_zidio/pages/signup.dart';


void main() {
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
