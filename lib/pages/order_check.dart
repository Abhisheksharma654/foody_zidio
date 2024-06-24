import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Ordered extends StatefulWidget {
  const Ordered({Key? key}) : super(key: key);

  @override
  State<Ordered> createState() => _OrderedState();
}

class _OrderedState extends State<Ordered> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // State variables
  bool isLoading = true;
  late List<DocumentSnapshot> orders;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  // Fetch orders placed by the current user
  void fetchOrders() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .get();

      setState(() {
        orders = querySnapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ordered Items'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(child: Text('No orders placed yet.'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot order = orders[index];
                    return ListTile(
                      title: Text(order['itemName']),
                      subtitle: Text('Price: ${order['itemPrice']}'),
                      trailing: Text('Quantity: ${order['itemQuantity']}'),
                      // Add more details as needed (e.g., date, status)
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}
