import 'package:flutter/material.dart';
import 'package:foody_zidio/Content/bottom_nav.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccessfull extends StatefulWidget {
  const PaymentSuccessfull({Key? key}) : super(key: key);

  @override
  _PaymentSuccessfullState createState() => _PaymentSuccessfullState();
}

class _PaymentSuccessfullState extends State<PaymentSuccessfull> {
  bool navigateToBottomNav = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 700, // Adjust size as needed
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Lottie.asset(
                        'images/Payment_success.json', // Replace with your JSON file path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 100),
            GestureDetector(
              onTap: () {
                setState(() {
                  navigateToBottomNav = true; // Set flag to navigate to BottomNav
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNav()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Keep Shopping",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
