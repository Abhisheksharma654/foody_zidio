import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList extends StatefulWidget {
  final String userId;

  const ShoppingList({required this.userId, Key? key}) : super(key: key);

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  late Stream<QuerySnapshot> paymentHistoryStream;

  @override
  void initState() {
    super.initState();
    loadPaymentHistory();
  }

  void loadPaymentHistory() {
    paymentHistoryStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('payment_history')
        .orderBy('Timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shopping List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: paymentHistoryStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    "No shopping history available.",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    data["Image"],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(data["Name"]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Quantity: ${data["Quantity"]}"),
                    Text("\u{20B9}${data["Total"]}"),
                    Text(
                      "Date: ${(data["Timestamp"] as Timestamp).toDate().toString()}",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              );
            },
          );
        },
      ),
    );
  }
}
