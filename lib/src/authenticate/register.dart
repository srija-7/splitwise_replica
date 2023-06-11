import 'package:fluttertoast/fluttertoast.dart';
import 'package:splitwise_app_replica/Screens/Animations/spinners.dart';
import 'package:splitwise_app_replica/constants.dart';
import 'package:splitwise_app_replica/services/database.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app_replica/services/auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  static const id = "/register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();
  String email = '';
  String password = '';
  String error = '';
  String name = '';
  String phone = '';
  bool animation = false;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
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
                          labelText: 'Full Name',
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
                            return "Enter an non null Name";
                          } else {
                            return val.isEmpty ? "Enter a Name" : null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Your email address',
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
                            return val.length < 6
                                ? "Enter a password of minimum 6 chars"
                                : null;
                          }
                        },
                        obscureText: _obscureText,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),

                      Container(
                        height: 30.0,
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
                                style: TextStyle(
                                    color: colorTheme
                                ),
                              ),

                            ),
                          ),
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    animation = true;
                                  });
                                  dynamic result = await _auth
                                      .registerWithEmailAndPassword(email, password);

                                  if (result == null) {
                                    setState(() {
                                      error = 'Enter a valid email';
                                      animation = false;
                                    });
                                    Fluttertoast.showToast(msg: error);
                                  } else {
                                    Navigator.pop(context);
                                    await _db.CreateUser(
                                        result.uid, email, name);
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
                                "Done",
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
