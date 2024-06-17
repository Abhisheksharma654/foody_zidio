import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    try {
      await _firestore.collection('users').doc(id).set(userInfoMap);
      print('User added to Firestore with ID: $id');
    } catch (e) {
      print('Error adding user to Firestore: $e');
      // Handle error as needed
    }
  }

  Future<void> updateUserWallet(String id, String amount) async {
    try {
      await _firestore.collection("users").doc(id).update({"Wallet": amount});
      print('Wallet updated for user ID: $id');
    } catch (e) {
      print('Error updating wallet: $e');
      // Handle error as needed
    }
  }

  Future<void> addFoodItem(Map<String, dynamic> foodItem, String s) async {
    try {
      await _firestore.collection('foodItems').add(foodItem);
      print('Food item added to Firestore');
    } catch (e) {
      print('Error adding food item: $e');
      // Handle error as needed
    }
  }

  Future<void> addFoodToCart(Map<String, dynamic> foodData, String userId) async {
    try {
      await _firestore.collection('users').doc(userId).collection('cart').add(foodData);
      print('Food added to cart for user ID: $userId');
    } catch (e) {
      print('Error adding food to cart: $e');
      // Handle error as needed
    }
  } 

  Future<Stream<QuerySnapshot>> getFoodCart(String userId) async {
    return _firestore.collection('users').doc(userId).collection('cart').snapshots();
  }
}

