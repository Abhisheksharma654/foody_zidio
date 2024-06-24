import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foody_zidio/pages/home.dart';
import 'package:foody_zidio/pages/order.dart';

class Ordered extends StatefulWidget {
  const Ordered({super.key});

  @override
  State<Ordered> createState() => _OrderedState();
}

class _OrderedState extends State<Ordered> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> placeOrder() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // Fetch cart items
      QuerySnapshot cartSnapshot = await _firestore
          .collection('cartItems')
          .where('userId', isEqualTo: user.uid)
          .get();

      // Prepare order data
      List<Map<String, dynamic>> orderItems = cartSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['orderId'] = _firestore.collection('orders').doc().id;
        return data;
      }).toList();

      // Add order to the orders collection
      WriteBatch batch = _firestore.batch();
      for (var item in orderItems) {
        DocumentReference orderRef =
            _firestore.collection('orders').doc(item['orderId']);
        batch.set(orderRef, item);
      }

      // Remove items from cart
      for (var doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      // Notify user
      print('Order placed successfully');
    } catch (e) {
      print('Error placing order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => Ordered(),
            ),
          );
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
