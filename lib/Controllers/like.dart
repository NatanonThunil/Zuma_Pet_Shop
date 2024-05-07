import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zumas_pet_shop/models/products.dart';

class Favorite {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Stream<List<Map<String, dynamic>>> streamFavorite() {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Favorite')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (error) {
      // Handle errors if necessary
      print('Error reading transaction information: $error');
      return Stream.error(
          'Error reading transaction information'); // Return an error stream
    }
  }

  Future<bool> alreadyFavorite(String productId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Favorite')
          .doc(productId)
          .get();

      return docSnapshot.exists;
    } catch (e) {
      // Handle errors, e.g., print an error message
      print('Error checking favorite status: $e');
      return false; // Return false in case of error
    }
  }

  Future<void> toggleFavoriteStatus(
      String productId, String productName) async {
    try {
      final favoriteRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Favorite')
          .doc(productId);

      final docSnapshot = await favoriteRef.get();

      if (docSnapshot.exists) {
        await favoriteRef.delete();
      } else {
        await favoriteRef.set({
          'Favorited Date': FieldValue.serverTimestamp(),
          'ProductId': productId,
          'ProductName': productName,
        });
      }
    } catch (e) {
      // Handle errors, e.g., print an error message
      print('Error toggling favorite status: $e');
    }
  }

  Stream<List<Product>> readUserProducts() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Favorite')
        .snapshots()
        .asyncMap((QuerySnapshot cartSnapshot) async {
      List<Product> cartProducts = [];

      for (QueryDocumentSnapshot cartDoc in cartSnapshot.docs) {
        String productId = cartDoc.id;

        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get();

        if (productSnapshot.exists) {
          Map<String, dynamic> productData =
              productSnapshot.data() as Map<String, dynamic>;
          Product product = Product.fromJson(productData);
          cartProducts.add(product);
        }
      }

      return cartProducts;
    });
  }
}
