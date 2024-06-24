import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foody_zidio/service/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> addFoodToCart(Map<String, dynamic> foodItem, String userId) async {
    try {
      await _firestore.collection('users').doc(userId).collection('cart').add(foodItem);
      print('Food item added to cart for user ID: $userId');
    } catch (e) {
      print('Error adding food to cart: $e');
      // Handle error as needed
    }
  }

  Future<void> updateCartItemQuantity(String userId, String docId, int quantity) async {
    try {
      await _firestore.collection('users').doc(userId).collection('cart').doc(docId).update({"Quantity": quantity.toString()});
      print('Cart item quantity updated for user ID: $userId');
    } catch (e) {
      print('Error updating cart item quantity: $e');
    }
  }

  Future<void> deleteCartItem(String userId, String docId) async {
    try {
      await _firestore.collection('users').doc(userId).collection('cart').doc(docId).delete();
      print('Cart item deleted for user ID: $userId');
    } catch (e) {
      print('Error deleting cart item: $e');
    }
  }

  Future<Stream<QuerySnapshot>> getFoodCart(String userId) async {
    return _firestore.collection('users').doc(userId).collection('cart').snapshots();
  }

  Future<Stream<QuerySnapshot>> getFoodItems() async {
    return _firestore.collection('foodItems').snapshots();
  }
    // Method to get the current value of the user ID counter
  Future<int> getLastUserId() async {
    DocumentSnapshot counterDoc = await _firestore.collection('counters').doc('userCounter').get();
    if (counterDoc.exists) {
      return counterDoc['lastUserId'];
    } else {
      return 0; // Initial value if the document doesn't exist
    }
  }

  // Method to increment the user ID counter
  Future<void> incrementUserIdCounter() async {
    DocumentReference counterRef = _firestore.collection('counters').doc('userCounter');
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterRef);
      if (snapshot.exists) {
        int newUserId = snapshot['lastUserId'] + 1;
        transaction.update(counterRef, {'lastUserId': newUserId});
      } else {
        transaction.set(counterRef, {'lastUserId': 1});
      }
    });
  }

  // Add user details with auto-increment ID
  Future<void> addUserDetailWithAutoIncrement(Map<String, dynamic> userInfoMap) async {
    int newUserId = await getLastUserId() + 1;
    await incrementUserIdCounter();
    userInfoMap['Id'] = newUserId.toString(); // Assuming ID is stored as a string
    await _firestore.collection('users').doc(newUserId.toString()).set(userInfoMap);
    print('User added to Firestore with ID: $newUserId');
  }
Future<void> updateUserProfile(String userId, String name, String email, String profile) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'name': name,
        'email': email,
        'profile': profile,
      });
      print('User profile updated for user ID: $userId');
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

}
