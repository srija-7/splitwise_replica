import 'package:splitwise_app_replica/constants.dart';
import 'package:splitwise_app_replica/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:splitwise_app_replica/src/authenticate/register.dart';
import 'package:splitwise_app_replica/src/authenticate/signin.dart';
import 'package:splitwise_app_replica/services/auth.dart';

class Authenticate extends StatefulWidget {
  // const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Image(
                image: AssetImage("assets/logos/sw.png"),
                height: 180.0,
              ),
              // Spacer(),

              const SizedBox(height: 8,),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login into your Account to continue!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'aerial',

                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Register.id);
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(76, 187, 155, 1),
                  minimumSize: const Size(double.maxFinite, 40.0),
                  elevation: 5.0,
                  foregroundColor: Colors.white
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),

              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(SignIn.id);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.maxFinite, 40.0),
                  elevation: 5.0,
                  foregroundColor: colorTheme
                ),
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),

              ),

              const SizedBox(
                height: 30,
              ),
              TextButton.icon(
                onPressed: () async {
                  dynamic result = await _auth.googleLogIn();
                  await _db.CreateUser(
                  result.uid, result.email, result.name);
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.maxFinite, 40.0),
                    elevation: 5.0,
                    foregroundColor: colorTheme
                ),
                label: const Text(
                  "Sign In with Google",
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
                icon: Image.asset(
                  "assets/google-logo.png",
                  height: 24.0,
                  width: 24.0,
                )
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          )),
    );
  }
}
