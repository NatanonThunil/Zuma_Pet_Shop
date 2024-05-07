import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Balance {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Stream<String> readUserBalance() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      final balance = snapshot.data()?['balance'] ?? 0;
      return balance.toString();
    });
  }

  Future<void> topup(double amount) async {
    // Start a new batch operation to deduct the total_price from the user's balance
    WriteBatch balanceBatch = FirebaseFirestore.instance.batch();

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    balanceBatch.update(userDocRef, {'balance': FieldValue.increment(amount)});

    // Commit the batch operation to deduct the balance
    await balanceBatch.commit();

    final transaction = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Transaction')
        .doc();

    await transaction.set({
      'Transaction Date': FieldValue.serverTimestamp(),
      'Amount': amount,
      'invoiceId': null,
      '_isReduction': false,
    });
  }

  Future<void> reduction(double amount, String invoiceId) async {
    final transaction = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Transaction')
        .doc();

    await transaction.set({
      'Transaction Date': FieldValue.serverTimestamp(),
      'Amount': amount,
      'invoiceId': invoiceId,
      '_isReduction': true,
    });
  }

  Stream<List<Map<String, dynamic>>> streamTransaction() {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Transaction')
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
}
