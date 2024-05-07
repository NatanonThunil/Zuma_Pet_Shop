import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zumas_pet_shop/Controllers/balance.dart';
import 'package:zumas_pet_shop/models/products.dart';

class Invoice {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<String> makeAPurchase(double totalPrice) async {
    try {
      // Check if the user can afford the purchase
      final bool canAfford = await checkIfUserAbleToPay(totalPrice);
      if (!canAfford) {
        // Return or handle insufficient balance
        return '';
      }

      // Generate a random document ID for the Invoice
      final String invoiceId = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Invoice')
          .doc()
          .id; // Generate the ID here

      final forInformation = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Invoice')
          .doc(invoiceId); // Use the generated ID

      // Fetch the user's current balance before the purchase
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final initialBalance = userDoc.data()?['balance'] ?? 0;

      // Start a batch write operation
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Reference to the Cart collection
      final cartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Cart');

      // Reference to the target Invoice collection
      final targetCollection = forInformation.collection('information');

      // Get all documents from the Cart collection
      final cartQuerySnapshot = await cartCollection.get();

      // Iterate over each document in the Cart collection
      cartQuerySnapshot.docs.forEach((doc) {
        // Add the document data to the target Invoice collection
        batch.set(targetCollection.doc(doc.id), doc.data());

        // Get the productId from the cart item
        final productId = doc.data()['productId'];

        // Reference to the product document
        final productRef =
            FirebaseFirestore.instance.collection('products').doc(productId);

        // Increment the soldAmount field in the product document
        batch.update(productRef, {'soldAmount': FieldValue.increment(1)});

        // Delete the original document from the Cart collection
        batch.delete(doc.reference);
      });

      // Commit the batch operation to move cart items to the invoice
      await batch.commit();

      // Set data for the Invoice document
      await forInformation.set({
        'Invoice ID': invoiceId,
        'Date Added': FieldValue.serverTimestamp(),
        'Initial Balance': initialBalance,
        'Total Price': totalPrice,
        'Final Balance': initialBalance - totalPrice,
      });

      // Start a new batch operation to deduct the total_price from the user's balance
      WriteBatch balanceBatch = FirebaseFirestore.instance.batch();
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      balanceBatch
          .update(userDocRef, {'balance': FieldValue.increment(-totalPrice)});

      // Commit the batch operation to deduct the balance
      await balanceBatch.commit();

      Balance().reduction(totalPrice, invoiceId);

      // Return the ID of the newly created Invoice document
      return invoiceId;
    } catch (error) {
      // Handle errors if necessary
      print('Error making a purchase: $error');
      return ''; // Return an empty string in case of error
    }
  }

  Future<bool> checkIfUserAbleToPay(double total_price) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    final balance = userDoc.data()?['balance'] ?? 0;
    if (balance < total_price) {
      return false;
    }
    return true;
  }

  Stream<List<Product>> readUserProducts(String? invoiceId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Invoice')
        .doc(invoiceId)
        .collection('information')
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

  Stream<Map<String, dynamic>> streamInvoiceInformation(String? invoiceId) {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Invoice')
          .doc(invoiceId)
          .snapshots()
          .map((snapshot) {
        if (!snapshot.exists) {
          return {}; // Return an empty map if the invoice document doesn't exist
        }

        final Map<String, dynamic> invoiceData =
            snapshot.data() as Map<String, dynamic>;

        return {
          'Date Added': invoiceData['Date Added'],
          'Final Balance': invoiceData['Final Balance'],
          'Initial Balance': invoiceData['Initial Balance'],
          'Invoice ID': invoiceData['Invoice ID'],
          'Total Price': invoiceData['Total Price'],
        };
      });
    } catch (error) {
      // Handle errors if necessary
      print('Error reading invoice information: $error');
      return Stream.value({}); // Return an empty map in case of error
    }
  }
}
