import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:foody_zidio/Content/onboard.dart';
import 'package:foody_zidio/main.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 300, // Adjust this size as needed
              height: 300, // Adjust this size as needed
              child: Lottie.asset(
                'images/Loder_foody.json',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      nextScreen: Checkuser(),
      splashIconSize: 300,
      backgroundColor: Colors.grey,
    );
  }
}
