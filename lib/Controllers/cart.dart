import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Cart {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> addItemToCart(String? productId, String? productName) async {
    final addCart = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart')
        .doc(productId);

    addCart.get().then((docSnapshot) async {
      if (docSnapshot.exists) {
        // Document exists, do something
        return;
      } else {
        final json = {
          'productId': productId,
          'productName': productName,
          'Date Added': FieldValue.serverTimestamp(),
        };

        await addCart.set(json);
        // Document does not exist, handle accordingly
      }
    }).catchError((error) {
      // Handle errors
    });
  }

  Future<bool> isExist(String? productId) async {
    final productCart = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart')
        .doc(productId);

    try {
      final docSnapshot = await productCart.get();
      return docSnapshot.exists;
    } catch (error) {
      // Handle errors if necessary
      return false;
    }
  }
}
