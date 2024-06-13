import 'package:flutter/material.dart';
import 'package:foody_zidio/pages/login.dart';
import 'package:foody_zidio/pages/signup.dart';
import 'package:foody_zidio/widget/content_model.dart';
import 'package:foody_zidio/widget/widget_support.dart';

class Onboard extends StatefulWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[i].image,
                        height: 450,
                        width: MediaQuery.of(context).size.width / 1.5,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        contents[i].title,
                        style: AppWidget.semiBoldTextFeildStyle(),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        contents[i].description,
                        style: AppWidget.LightTextFeildStyle(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex == contents.length - 1) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const LogIn()));
              }
              _controller.nextPage(
                duration: const Duration(milliseconds: 100),
                curve: Curves.bounceIn,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius:
                    BorderRadius.circular(20), // Add the border radius here
              ),
              height: 40,
              margin: const EdgeInsets.all(40),
              width: double.infinity,
              child: const Center(
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10.0,
      width: currentIndex == index ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.black38,
      ),
    );
  }
}
