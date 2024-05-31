import 'package:flutter/material.dart';
import 'package:foody_zidio/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false, burger = false, salad = false, pizza = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hey USER,",
                  style: AppWidget.boldTextFeildStyle(),
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Yummy Food",
              style: AppWidget.HeadlineTextFeildStyle(),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "Discover and Get Great Food",
              style: AppWidget.LightTextFeildStyle(),
            ),
            SizedBox(
              height: 20.0,
            ),
            showitem(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Image.asset(
                      "images/salad2.png",
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget showitem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            icecream = true;
            burger = false;
            salad = false;
            pizza = false;
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: icecream ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(8),
              child: Image.asset("images/ice-cream.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  color: icecream ? Colors.white : Colors.black),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecream = false;
            burger = true;
            salad = false;
            pizza = false;
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: burger ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(8),
              child: Image.asset("images/burger.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  color: burger ? Colors.white : Colors.black),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecream = false;
            burger = false;
            salad = true;
            pizza = false;
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: salad ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(8),
              child: Image.asset("images/salad.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  color: salad ? Colors.white : Colors.black),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecream = false;
            burger = false;
            salad = false;
            pizza = true;
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: pizza ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(8),
              child: Image.asset("images/pizza.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  color: pizza ? Colors.white : Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
