import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitwise_app_replica/models/user.dart';
import 'package:splitwise_app_replica/src/authenticate/authenticate.dart';
import 'package:splitwise_app_replica/src/MainPage.dart';

class Wrapper extends StatelessWidget {
  // const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<myUser?>(context);

    // return home or authenticate
    if (user == null) {
      return Authenticate();
    } else {
      return MainPage(uid: user.uid);
    }
  }
}
