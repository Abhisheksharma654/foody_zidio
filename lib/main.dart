import 'package:flutter/material.dart';
import 'package:foody_zidio/pages/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp (
   debugShowCheckedModeBanner: false,
   title: 'Foody',
   theme: ThemeData(
    primaryColor: Colors.yellow,
    visualDensity: VisualDensity.adaptivePlatformDensity,
   ),
   home: LogIn(),
    );
  }
}
