 import 'package:flutter/material.dart';
 import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: const Color.fromRGBO(76, 187, 155, 1),
                minimumSize: const Size(350, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
                // TODO: Implement login functionality
              },
              child: const Text('Sign up'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(225, 255, 255, 255),
                minimumSize: const Size(350, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
                // TODO: Implement login functionality
              },
              child: const Text(
                'Log in',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(225, 255, 255, 255),
                minimumSize: const Size(350, 50),
              ),
              onPressed: () {
                //  dynamic result = await _auth.googleLogIn();
                // await _db.CreateUser(
                //     result.uid, result.email, result.password, result.name);
                // if (result == null) {
                //   print("ERROR!!");
                // } else {
                //   print("GR* SUCSES");
                // }
              },
                // TODO: Implement login functionality
              
              child: const Text(
                'Sign in with Google',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
