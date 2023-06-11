import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splitwise_app_replica/Screens/Animations/spinners.dart';
import 'package:splitwise_app_replica/constants.dart';
import 'package:splitwise_app_replica/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app_replica/src/authenticate/forgotpass.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  static const id = "/sign_in";

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String error = '';
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool animation = false;
  @override
  Widget build(BuildContext context) {
    return animation ? const Spinner() : Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/logos/sw-wide.png",
                          height: 50.0,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 60.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Email address',
                          contentPadding: EdgeInsets.only(
                              bottom: 0.0
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: colorTheme,
                                  width: 2.0
                              )
                          )
                      ),
                      validator: (val) {
                        if (val == null) {
                          return "Enter an non null email";
                        } else {
                          return val.isEmpty ? "Enter an email" : null;
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),

                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Your Password',
                          suffixIcon: IconButton(
                            icon: _obscureText ? const Icon(
                              Icons.visibility,
                              color: Colors.grey,
                            ) : const Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          contentPadding: const EdgeInsets.only(
                              bottom: 0.0
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: colorTheme,
                                  width: 2.0
                              )
                          )
                      ),
                      validator: (val) {
                        if (val == null) {
                          return "Enter a non null password of minimum 6 chars";
                        } else {
                          return val.length < 6 ? "Incorrect Password" : null;
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      obscureText: _obscureText,
                    ),

                    Container(
                      height: 20.0,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ForgotPassword.id);
                      },
                      child: Text("Forgot Password", style: TextStyle(color: colorTheme),)
                    ),

                    Container(
                      height: 80.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(173, 173, 173, 1),
                                  width: 1.0
                              ),
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          width: 120.0,
                          height: 50.0,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: colorTheme
                            ),
                            child: const Text(
                              "Back",
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromRGBO(173, 173, 173, 1),
                                  width: 1.0
                              ),
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          width: 120.0,
                          height: 50.0,
                          child: TextButton(

                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  animation = true;
                                });
                                dynamic result = await _auth
                                    .signInWithEmailAndPassword(email, password);

                                if (result == null) {
                                  setState(() {
                                    error = 'Incorrect Email or Password';
                                    animation = false;
                                  });
                                  Fluttertoast.showToast(msg: error);
                                } else {
                                  Navigator.pop(context);
                                  setState(() {
                                    error = '';
                                  });
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: colorTheme,
                              foregroundColor: Colors.white
                            ),
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ],

                    ),
                    Container(
                      height: 40.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );

  }
}
