import 'package:flutter/material.dart';

class NormAlert {
  final String atitle;
  final String acontext;

  NormAlert({required this.atitle, required this.acontext});

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(atitle),
          content: Text(acontext),
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
}
