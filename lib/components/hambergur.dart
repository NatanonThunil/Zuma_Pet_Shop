import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zumas_pet_shop/pages/LoginCon.dart';
import 'package:zumas_pet_shop/pages/auth.dart';
import 'package:zumas_pet_shop/pages/mycart.dart';
import '../pages/payment.dart';
import '../pages/setting.dart';

class LeftHambergur extends StatelessWidget {
  final Auth _auth = Auth(); // Instantiate the Auth class

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      print('Sign out successful');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginCon(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Z U M A',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the drawer
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('My Cart'),
            trailing: const Icon(Icons.shopping_cart, color: Colors.black),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyCart()));
            },
            tileColor: Colors.white,
            shape: const Border(
              bottom: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          ListTile(
            title: const Text('Payment'),
            trailing: const Icon(Icons.payment, color: Colors.black),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PaymentPage()));
            },
            tileColor: Colors.white,
            shape: const Border(
              bottom: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          ListTile(
            title: const Text('Settings'),
            trailing: const Icon(Icons.settings, color: Colors.black),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ZumaSetting()));
            },
            tileColor: Colors.white,
            shape: const Border(
              bottom: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          ListTile(
            title: const Text('Contact Us'),
            trailing: const Icon(Icons.contact_mail, color: Colors.black),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Contact us'),
                    content: Text(
                        'Email : DekshineEiX2000@gmail.co.th.mfu.mcu.dc.microhard.cn.th'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  );
                },
              );
            },
            tileColor: Colors.white,
            shape: const Border(
              bottom: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          ListTile(
            title: const Text('Log Out'),
            trailing: const Icon(Icons.exit_to_app, color: Colors.black),
            onTap: () {
              signOut(context);
            },
            tileColor: Colors.white,
            shape: const Border(
              bottom: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ],
      ),
    );
  }
}
