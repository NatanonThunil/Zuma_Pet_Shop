import 'package:firebase_auth/firebase_auth.dart';
import 'package:zumas_pet_shop/pages/auth.dart';
import 'package:flutter/material.dart';
import '../pages/signup.dart';
import '../pages/homepage.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  Auth _auth = Auth(); // Create an instance of your Auth class

  Future<void> signInWithEmailAndPass() async {
    try {
      await _auth.signInWithEmailAndPass(
          email: _emailController.text, password: _passwordController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _validEmail = true;
  bool _validPasswordLength = true;
  void _validateEmail(String email) {
    setState(() {
      _validEmail = RegExp(r"^[a-zA-Z0-9+.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email);
    });
  }

  void _checkPasswordLength() {
    setState(() {
      _validPasswordLength = _passwordController.text.length >= 6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/zuma-icon.png'),
                height: 260,
                width: 260,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .black), // Custom underline color when focused
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          errorText: _validEmail ? null : 'Enter a valid email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => _validateEmail(value),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                          autofocus: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .black), // Custom underline color when focused
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            errorText: _validPasswordLength
                                ? null
                                : 'Password is too short, should be longer than 6 characters.',
                          ),
                          obscureText: true,
                          onChanged: (_) {
                            _checkPasswordLength();
                          }),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            // Add action for "forgot password" button
                          },
                          child: Text('Forgot Password?',
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      errorMessage == null ? '' : '$errorMessage',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Perform login action if email is valid and password is not empty
                        if (_validEmail &&
                            _passwordController.text.isNotEmpty) {
                          signInWithEmailAndPass();
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // Background color
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(color: Colors.black)), // Text color
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(8.0)), // Padding
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(
                                    color: Colors.black, width: 2.0)),
                          ),
                          splashFactory: NoSplash.splashFactory),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupApp()));
                      },
                      child: Text('Create an account? Sign up',
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
