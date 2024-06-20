import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foody_zidio/pages/details.dart';
import 'package:foody_zidio/pages/myorder.dart';
import 'package:foody_zidio/service/shared_pref.dart';
import 'package:foody_zidio/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool icecream = false, pizza = false, salad = false, burger = false;
  bool dataAvailable = true; // Flag to check if data is available
  late Timer timer; // Timer for shimmer duration
  late List<DocumentSnapshot> foodItems; // List to store food items
  String userName = "User"; // Default user name

  @override
  void initState() {
    super.initState();
    // Initialize foodItems as an empty list
    foodItems = [];
    // Simulate data loading delay for demonstration (you can replace with actual data loading logic)
    timer = Timer(Duration(milliseconds: 500), () {
      fetchData();
    });
    // Fetch user name from shared preferences or Firestore
    onthisload();
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }

  // Fetch food data from Firestore
  void fetchData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('foodItems').get();
      setState(() {
        foodItems = querySnapshot.docs;
        dataAvailable = foodItems.isNotEmpty;
      });
    } catch (e) {
      print('Error fetching food items: $e');
      setState(() {
        dataAvailable = false;
      });
    }
  }

  // Fetch user name from shared preferences or Firestore
  Future<void> fetchUserName() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // First, try to get the user name from shared preferences
        userName = await SharedPreferenceHelper().getUserName() ?? "User";

        // If userName is still the default, fetch from Firestore
        if (userName == "User") {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('User_data')
              .doc(currentUser.uid)
              .get();
          setState(() {
            userName = userDoc['name'] ?? 'User';
          });

          // Save the fetched name to shared preferences
          await SharedPreferenceHelper().saveUserName(userName);
        }
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  Future<void> onthisload() async {
    await fetchUserName();
    setState(() {});
  }

  // Filter food items based on the selected category
  List<DocumentSnapshot> getFilteredFoodItems() {
    if (icecream) {
      return foodItems.where((doc) => doc['Category'] == 'Ice Cream').toList();
    } else if (pizza) {
      return foodItems.where((doc) => doc['Category'] == 'Pizza').toList();
    } else if (salad) {
      return foodItems.where((doc) => doc['Category'] == 'Salad').toList();
    } else if (burger) {
      return foodItems.where((doc) => doc['Category'] == 'Burger').toList();
    } else {
      return foodItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello, $userName", // Display dynamic username
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text("Delicious Food",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
              Text("Discover and Get Great Food",
                  style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 20.0),
              Container(
                  margin: EdgeInsets.only(right: 20.0), child: showItem()),
              SizedBox(height: 30.0),
              dataAvailable
                  ? buildFoodItemsList()
                  : Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'images/no_data.png',
                            width: 400,
                            height: 400,
                          ),
                          Text(
                            "Oops ..... \n There is no any type of item are available..",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFoodItemsList() {
    List<DocumentSnapshot> filteredFoodItems = getFilteredFoodItems();
    return Column(
      children: filteredFoodItems.map((doc) {
        String name = doc['Name'];
        String image = doc['Image'];
        String price = doc['Price'];
        return foodCard(
          context,
          name,
          image,
          price,
        );
      }).toList(),
    );
  }

  Widget foodCard(
    BuildContext context,
    String title,
    String imagePath,
    String $price,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Details(
              detail:
                  "", // Pass an empty string or null if not used in Details page
              image: imagePath,
              name: title,
              price: $price,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(4),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  imagePath,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10.0),
                Text(
                  title,
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
                SizedBox(height: 5.0),
                Text(
                  '\u{20B9}' + $price,
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            icecream = true;
            pizza = false;
            salad = false;
            burger = false;
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
              child: Image.asset(
                "images/ice-cream.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: icecream ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecream = false;
            pizza = true;
            salad = false;
            burger = false;
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
              child: Image.asset(
                "images/pizza.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: pizza ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecream = false;
            pizza = false;
            salad = true;
            burger = false;
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
              child: Image.asset(
                "images/salad.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: salad ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecream = false;
            pizza = false;
            salad = false;
            burger = true;
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
              child: Image.asset(
                "images/burger.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: burger ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
