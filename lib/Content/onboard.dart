import 'package:flutter/material.dart';
import 'package:foody_zidio/widget/content_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foody_zidio/widget/widget_support.dart';
import 'package:foody_zidio/pages/signup.dart';


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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
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
                      padding: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.05,
                        horizontal: constraints.maxWidth * 0.05,
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            contents[i].image,
                            height: constraints.maxHeight * 0.5,
                            width: constraints.maxWidth,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.05,
                          ),
                          Text(
                            contents[i].title,
                            style: AppWidget.HeadlineTextFeildStyle(),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          Text(
                            contents[i].description,
                            style: AppWidget.LightTextFeildStyle(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                  (index) => buildDot(index, context),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (currentIndex == contents.length - 1) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('onboardingComplete', true);
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => SignUp()));
                  } else {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.bounceIn,
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: constraints.maxHeight * 0.08,
                  margin: EdgeInsets.all(constraints.maxWidth * 0.1),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      currentIndex == contents.length - 1 ? "Start" : "Next",
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
          );
        },
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10.0,
      width: currentIndex == index ? 18 : 7,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.black38,
      ),
    );
  }
}
