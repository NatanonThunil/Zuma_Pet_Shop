import 'package:flutter/material.dart';
import 'package:zumas_pet_shop/pages/auth.dart';
import 'package:zumas_pet_shop/pages/homepage.dart';
import 'package:zumas_pet_shop/pages/signin.dart';

class LoginCon extends StatefulWidget {
  const LoginCon({Key? key}) : super(key: key);

  @override
  State<LoginCon> createState() => _LoginConState();
}

class _LoginConState extends State<LoginCon> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
