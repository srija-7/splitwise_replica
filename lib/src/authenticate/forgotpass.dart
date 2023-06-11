import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splitwise_app_replica/constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  static const id = "/forgotPass";
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  String email = "";
  String error = '';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                TextField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: 'Email address',
                      contentPadding: EdgeInsets.only(
                          bottom: 0.0
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: colorTheme
                        )
                      )
                  ),
                ),
                Container(
                  height: 50.0,
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
                        child: Text("Back", style: TextStyle(color: colorTheme),)
                      )
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
                          await FirebaseAuth.instance.sendPasswordResetEmail(email:email!)
                          .onError((error, stackTrace) => {
                            Fluttertoast.showToast(msg: "No such user")
                          });
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: colorTheme,
                            foregroundColor: Colors.white
                        ),
                        child: const Text(
                          "Reset",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
