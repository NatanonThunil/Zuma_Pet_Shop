import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zumas_pet_shop/pages/auth.dart';
import '../pages/signin.dart';

class SignupApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? errorMessage = '';
  bool isLogin = true;

  Auth _auth = Auth();

  Future<void> signUpWithEmailAndPass() async {
    try {
      await _auth.SignUpWithEmailAndPass(
          email: _emailController.text, password: _passwordController.text);

      // Listen to authentication state changes to get the user's information
      _auth.authStateChanges.take(1).listen((User? user) {
        if (user != null) {
          // User signed up successfully, get the user's UUID and initialize user data
          _auth.CreateUserEss(user.uid, user.email);

          // Navigate to the login page or any other page as needed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        print(errorMessage);
      });
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _passwordsMatch = true;
  bool _validEmail = true;
  bool _validPasswordLength = true;

  void _checkPasswordMatch() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  void _checkPasswordLength() {
    setState(() {
      _validPasswordLength = _passwordController.text.length >= 6;
    });
  }

  void _validateEmail(String email) {
    setState(() {
      _validEmail = RegExp(r"^[a-zA-Z0-9+.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LoginApp()));
            },
          ),
          title: Text('Sign up'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              Image(
                image: AssetImage('assets/zuma-icon.png'),
                height: 260,
                width: 260,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          autofocus: true,
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
                            errorText: _validEmail
                                ? null
                                : 'Enter a valid email' +
                                    (errorMessage != ''
                                        ? ', $errorMessage'
                                        : ''),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => _validateEmail(value),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
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
                              _checkPasswordMatch();
                            }),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .black), // Custom underline color when focused
                            ),
                            labelText: 'Confirm password',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            errorText: _passwordsMatch
                                ? null
                                : 'Passwords do not match',
                          ),
                          obscureText: true,
                          onChanged: (_) => _checkPasswordMatch(),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        errorMessage == null ? '' : '$errorMessage',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          // Perform signup action if passwords match and email is valid
                          if (_passwordsMatch &&
                              _validEmail &&
                              _validPasswordLength) {
                            signUpWithEmailAndPass();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // Background color
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(color: Colors.black)), // Text color
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(10.0)), // Padding
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(
                                    color: Colors.black, width: 2.0)),
                          ),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Signup',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
