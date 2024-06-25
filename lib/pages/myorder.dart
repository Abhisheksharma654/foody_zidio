import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foody_zidio/Data/payment_successfull.dart';
import 'package:foody_zidio/Database/database.dart';
import 'package:foody_zidio/service/shared_pref.dart';
import 'package:foody_zidio/widget/widget_support.dart';

class Ordered extends StatefulWidget {
  const Ordered({super.key});

  @override
  State<Ordered> createState() => _OrderedState();
}

class _OrderedState extends State<Ordered> {
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
              margin:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[900], // Match the background color
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
                      color: Colors.grey[800], // Match the background color
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
                                color: Colors.white
                              ),
                            ),
                            Text(
                              quantity.toString(),
                              style: const TextStyle(fontSize: 16.0, color: Colors.white),
                            ),
                            Text(
                              "\u{20B9}" + itemTotal.toString(),
                              style: const TextStyle(fontSize: 16.0, color: Colors.white),
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
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Oops .....  Cart Is Empty.",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black, // Make app bar transparent
        elevation: 0, // Remove elevation
        title: Text("Food Cart", style: AppWidget.semiBoldWhiteTextFeildStyle()),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "\u{20B9}" + total.toString(),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                if (total == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: const Text(
                      "Please add some items to the cart!",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ));
                } else {
                  int walletAmount = int.parse(wallet!);
                  if (walletAmount >= total) {
                    int amount = walletAmount - total;
                    await DatabaseMethods()
                        .updateUserWallet(id!, amount.toString());
                    await SharedPreferenceHelper()
                        .saveUserWallet(amount.toString());

                    // Navigate to PaymentSuccessfull screen after successful payment
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentSuccessfull(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: const Text(
                        "Insufficient funds in wallet!",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ));
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
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
