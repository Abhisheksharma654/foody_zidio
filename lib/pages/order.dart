import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foody_zidio/Database/database.dart';
import 'package:foody_zidio/service/shared_pref.dart';
import 'package:foody_zidio/widget/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  int total = 0;
  Stream? foodStream;

  void startTimer() {
    Timer(const Duration(seconds: 3), () {
      setState(() {});
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getFoodCart(id!);
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    startTimer();
    super.initState();
  }

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
          // Group items by name
          Map<String, List<DocumentSnapshot>> groupedItems = {};
          for (var doc in snapshot.data.docs) {
            String name = doc['Name'];
            if (groupedItems.containsKey(name)) {
              groupedItems[name]!.add(doc);
            } else {
              groupedItems[name] = [doc];
            }
          }

          total = 0; // Reset total before recalculating
          List<Widget> itemWidgets = [];
          groupedItems.forEach((name, docs) {
            int quantity =
                docs.fold(0, (sum, doc) => sum + int.parse(doc["Quantity"]));
            int itemTotal = docs.fold(0, (sum, doc) {
              var data = doc.data() as Map<String, dynamic>;
              if (data.containsKey("Total")) {
                return sum + int.parse(data["Total"].toString());
              } else {
                return sum;
              }
            });

            total += itemTotal;

            itemWidgets.add(Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Dismissible(
                  key: Key(docs.first.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    await DatabaseMethods().deleteCartItem(id!, docs.first.id);
                    setState(() {
                      total -= itemTotal;
                    });
                  },
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    alignment: AlignmentDirectional.centerEnd,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            docs.first["Image"],
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              quantity.toString(),
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            Text(
<<<<<<< HEAD
                              "\u{20B9}" + itemTotal.toString(),
                              style: TextStyle(fontSize: 16.0),
=======
                              "\$" + itemTotal.toString(),
                              style: const TextStyle(fontSize: 16.0),
>>>>>>> a88ab7f2530e4000493dad9b03483a8d31145de9
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
          });

          return ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: itemWidgets,
          );
        } else {
          return Center(
            child: Column(
              children: [
                Image.asset(
                  'images/empty.png',
                  width: 300, // Adjusted size to be similar to home_no_data.png
                  height: 300, // Adjusted size to be similar to home_no_data.png
                ),
<<<<<<< HEAD
                SizedBox(
                  height: 10,
                ),
                Text(
=======
                const SizedBox(height: 10,),
                const Text(
>>>>>>> a88ab7f2530e4000493dad9b03483a8d31145de9
                  "Oops .....  Cart Is Empty.",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: const Center(
                  child: Text(
                    "Food Cart",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: foodCart(),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Price",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
<<<<<<< HEAD
                    "\u{20B9}" + total.toString(),
                    style: TextStyle(
=======
                    "\$" + total.toString(),
                    style: const TextStyle(
>>>>>>> a88ab7f2530e4000493dad9b03483a8d31145de9
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () async {
                int walletAmount = int.parse(wallet!);
                if (walletAmount >= total) {
                  int amount = walletAmount - total;
                  await DatabaseMethods()
                      .updateUserWallet(id!, amount.toString());
                  await SharedPreferenceHelper()
                      .saveUserWallet(amount.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment Successful!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Insufficient funds in wallet!')),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: const Center(
                  child: Text(
                    "CheckOut",
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
