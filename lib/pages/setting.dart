import 'package:flutter/material.dart';

class ZumaSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Z U M A'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Sorry, this feature isn\'t available right now :('),
      ),
    );
  }
}
