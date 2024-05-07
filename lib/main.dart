import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:zumas_pet_shop/pages/LoginCon.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginCon(),
      theme: ThemeData(
        textTheme: TextTheme(
          // Apply the custom TextStyle to all text styles
          bodyText1: TextStyle(
            fontFamily: 'Nunito',
            fontVariations: [
              FontVariation('ital', 0),
              FontVariation('wght', 800),
              FontVariation('ital', 1),
              FontVariation('wght', 800)
            ],
          ),
          // Add more text styles here if needed
        ),
      ),
    );
  }
}
