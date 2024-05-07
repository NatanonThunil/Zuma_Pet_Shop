import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zumas_pet_shop/Controllers/invoice.dart';
import 'package:zumas_pet_shop/models/products.dart';
import '../pages/Succesbuy.dart';

class MyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('Z U M A'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 500,
                width: 450,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: StreamBuilder<List<Product>>(
                  stream: readUserCart(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No items in cart'));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return CartItem(
                                product: snapshot.data![index],
                              );
                            },
                          );
                        }
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  final cartSnapshot = await readUserCart().first;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      double totalPrice = 0;
                      for (Product product in cartSnapshot) {
                        totalPrice += product.price;
                      }

                      return AlertDialog(
                        title: Text('Confirm item(s)'),
                        content: Column(children: [
                          Text(
                            'Total: \$${totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 20, color: Colors.lightBlueAccent),
                          ),
                          Container(
                            height: 400,
                            width: 300,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: cartSnapshot.length,
                                    itemBuilder: (context, index) {
                                      final product = cartSnapshot[index];
                                      return ListTile(
                                        title: Text(
                                          product.productName,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        subtitle: Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          TextButton(
                            onPressed: () async {
                              final ableToPay = await Invoice()
                                  .checkIfUserAbleToPay(totalPrice);
                              if (ableToPay && cartSnapshot.length != 0) {
                                final invoice_id =
                                    await Invoice().makeAPurchase(totalPrice);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SuccessBuy(invoiceId: invoice_id),
                                  ),
                                );
                              } else if (cartSnapshot.length == 0) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          Text('None of item(s) in your card.'),
                                      content: Text(
                                          'Please select your pet in \'Homepage\' first.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Insufficient Balance'),
                                      content: Text(
                                          'You do not have sufficient balance to make this purchase.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Close',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Text(
                      'B U Y',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<List<Product>> readUserCart() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Cart')
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

class CartItem extends StatelessWidget {
  final Product product;

  const CartItem({
    required this.product,
  });

  Future<void> deleteProductFromCart(String productId) async {
    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Cart');
      await cartRef.doc(productId).delete();
    } catch (error) {
      print('Error deleting product from cart: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(product.imgUrl),
          ),
          title: Text(
            product.productName,
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text(
            product.shopName,
            style: TextStyle(fontSize: 14),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$ ${product.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  deleteProductFromCart(product.id);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.black,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
