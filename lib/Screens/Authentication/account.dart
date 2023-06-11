import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
        backgroundColor:  const Color.fromRGBO(76, 187, 155, 1),
      ),
      body: Center(
        child: ElevatedButton(
           style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color.fromRGBO(76, 187, 155, 1);
                        }
                        return const Color.fromRGBO(76, 187, 155, 1);
                      }),
                    ),
          child: Text('Logout'),
          onPressed: () {
            signOut();
             // Navigator.of(context).pushNamed('/home');
          },
        ),
      ),
    );
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigator.of(context).pushReplacementNamed('/login'); // navigate to login screen
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      print(e.toString());
    }
  }
}
