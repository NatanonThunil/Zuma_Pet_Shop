import 'package:flutter/material.dart';

class OverlayExample extends StatefulWidget {
  @override
  _OverlayExampleState createState() => _OverlayExampleState();
}

class _OverlayExampleState extends State<OverlayExample> {
  bool _isOverlayVisible = false;

  void _toggleOverlayVisibility() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overlay Example'),
      ),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _toggleOverlayVisibility,
              child: Text('Show Overlay'),
            ),
          ),
          if (_isOverlayVisible)
            GestureDetector(
              onTap: _toggleOverlayVisibility,
              child: Container(
                color: Colors.black54,
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: _toggleOverlayVisibility,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
