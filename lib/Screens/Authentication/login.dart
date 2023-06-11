import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splitwise_app_replica/services/auth.dart';
import 'package:splitwise_app_replica/Screens/GroupScreens/homepage.dart';
import 'package:splitwise_app_replica/Screens/GroupScreens/group_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  String error = "";

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _requestEmailFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_emailFocusNode);
    });
  }

  void _requestPasswordFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splitwise Login'),
        backgroundColor: const Color.fromRGBO(76, 187, 155, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                onTap: _requestEmailFocus,
                validator: (val) {
                  if (val == null) {
                    return "Enter an non null email";
                  } else {
                    return val.isEmpty ? "Enter an email" : null;
                  }
                },
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(76, 187, 155, 1),
                      width: 2,
                    ),
                  ),
                  labelText: 'Email address',
                  labelStyle: TextStyle(
                    color: _emailFocusNode.hasFocus
                        ? const Color.fromRGBO(76, 187, 155, 1)
                        : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                focusNode: _passwordFocusNode,
                onTap: _requestPasswordFocus,
                validator: (val) {
                  if (val == null) {
                    return "Enter a non null password of minimum 6 chars";
                  } else {
                    return val.length < 6 ? "Incorrect Password" : null;
                  }
                },
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(76, 187, 155, 1),
                      width: 2,
                    ),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: _passwordFocusNode.hasFocus
                        ? const Color.fromRGBO(76, 187, 155, 1)
                        : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // final UserCredential userCredential =
                    if (_formkey.currentState!.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text);
                      if (result == null) {
                        setState(() {
                          error = 'Incorrect Email or Password';
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Login successful",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                            textColor: Colors.white);
                             setState(() {
                              error = '';
                            });
                        Navigator.of(context).pushNamed('/homepage');
                        // Navigate to home screen or perform any action after successful login
                        // print("hi");
              
                      }
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      Fluttertoast.showToast(
                          msg: "No user found for that email.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white);
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      Fluttertoast.showToast(
                          msg: "Wrong password provided for that user.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: Color.fromRGBO(76, 187, 155, 1),
                  minimumSize: Size(100, 45),
                ),
                child: const Text('Log in'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {

                  
                    //  await FirebaseAuth.instance.sendPasswordResetEmail(email:currentUser.email!);

                  // TODO: Implement forgot password functionality
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color.fromRGBO(76, 187, 155, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
