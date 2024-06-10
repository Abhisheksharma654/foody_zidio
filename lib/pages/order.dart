import 'package:flutter/material.dart';
import 'package:foody_zidio/widget/content_model.dart';
import 'package:foody_zidio/widget/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
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
          PageView.builder(
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
                      Image.asset(contents[i].image,
                          height: 450,
                          width: MediaQuery.of(context).size.width / 1.5,
                          fit: BoxFit.fill),
                      const SizedBox(height: 10.0),
                      Text(
                        contents[i].title,
                        style: AppWidget.semiBoldTextFeildStyle(),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        contents[i].description,
                        style: AppWidget.LightTextFeildStyle(),
                      )
                    ],
                  ),
                );
              }),
          GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  contents.length,
                  (index) => 
                        buildDot(index, context),
                      ),
            ),
          ),
         GestureDetector(child: Container(
              height: 60,
              margin: const EdgeInsets.all(40),
              width: double.infinity,
              child: Text("Next",style: AppWidget.semiBoldTextFeildStyle(),),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10.0,
      width: currentIndex == index?18:7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),color: Colors.black38),
    );
  }
}
