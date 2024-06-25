import 'package:flutter/material.dart';
import 'package:foody_zidio/Database/database.dart';
import 'package:foody_zidio/service/shared_pref.dart';
import 'package:foody_zidio/widget/widget_support.dart';

class Details extends StatefulWidget {
  final String image, name, detail, price;

  Details({
    required this.detail,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1, total = 0;
  String? userId;

  @override
  void initState() {
    super.initState();
    getSharedPref();
    total = int.parse(
        widget.price); // Initialize total price based on the item's price
  }

  // Fetch user ID from shared preferences
  void getSharedPref() async {
    userId = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          "Add To Cart",
          style: AppWidget.semiBoldWhiteTextFeildStyle(),
        ),
        centerTitle: true,
        backgroundColor: Colors.black, // Make app bar transparent
        elevation: 0, // Remove elevation
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
            top: 10.0, left: 20.0, right: 20.0), // Adjust top margin
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display item image
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                widget.image,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            // Display item name and quantity control
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: AppWidget.semiBoldWhiteTextFeildStyle(),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.detail,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppWidget.semiBoldWhite1TextFeildStyle(),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                // Quantity control buttons
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              --quantity;
                              total -= int.parse(widget.price);
                            });
                          }
                        },
                        icon: Icon(Icons.remove),
                        color: Colors.white,
                      ),
                      Text(
                        quantity.toString(),
                        style: TextStyle(fontSize: 16,color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            ++quantity;
                            total += int.parse(widget.price);
                          });
                        },
                        icon: Icon(Icons.add),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Display delivery time
            Row(
              children: [
                Icon(Icons.alarm, color: Colors.white),
                SizedBox(width: 5),
                Text(
                  "30 min",
                  style: AppWidget.semiBoldWhite1TextFeildStyle(),
                ),
              ],
            ),
            Spacer(),
            // Display total price and add to cart button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: AppWidget.semiBoldWhite1TextFeildStyle(),
                      ),
                      Text(
                        "\u{20B9}" + total.toString(),
                        style: AppWidget.HeadlineTextFeildStyle(),
                      ),
                    ],
                  ),
                  // Add to cart button
                  GestureDetector(
                    onTap: () async {
                      if (userId != null) {
                        Map<String, dynamic> addFoodtoCart = {
                          "Name": widget.name,
                          "Quantity": quantity.toString(),
                          "Total": total.toString(),
                          "Image": widget.image,
                        };
                        await DatabaseMethods()
                            .addFoodToCart(addFoodtoCart, userId!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.orangeAccent,
                            content: Text(
                              "Food Added to Cart",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add to Cart",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
