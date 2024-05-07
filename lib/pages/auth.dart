import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPass({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> SignUpWithEmailAndPass({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> CreateUserEss(
    String? uuid,
    String? email,
  ) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(uuid);

    final json = {
      'uid': uuid,
      'email': email,
      'balance': 0,
      'point': 0,
      'joinDate': FieldValue.serverTimestamp(),
    };

    await docUser.set(json);

    // final cart = docUser.collection('Cart');

    // // Add a document to the 'Cart' subcollection without specifying an ID
    // await cart.add({});

    print('200');
  }

  String? getCurrentUserUid() {
    return _firebaseAuth.currentUser?.uid;
  }
}
