import 'package:flutter/material.dart';
import 'package:splitwise_app_replica/Screens/Animations/animation.dart';
import 'package:splitwise_app_replica/Screens/Authentication/login.dart';
import 'package:splitwise_app_replica/Screens/Authentication/signup.dart';
import 'package:splitwise_app_replica/Expenses/expenses.dart';
import 'package:splitwise_app_replica/Screens/GroupScreens/showAllGroups.dart';
import 'package:splitwise_app_replica/constants.dart';
import 'package:splitwise_app_replica/home.dart';
import 'package:splitwise_app_replica/Screens/Authentication/account.dart';
import 'package:splitwise_app_replica/Screens/GroupScreens/group_page.dart';

import '../../bottomnavbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  int oweAmount = 0;

  @override
  Widget build(BuildContext context) {
    const amountTextStyle = TextStyle(color: Colors.amber, fontSize: 20.0);

    return Scaffold(
      appBar: AppBar(
        // title: Text("HomePage"),
        backgroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.group_add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    const Text(
                      "Overall you owe ",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      currencySymbols["rupee"],
                      style: amountTextStyle,
                    ),
                    Text(
                      oweAmount.toString(),
                      style: amountTextStyle,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                  iconSize: 35.0,
                )
              ],
            ),
            AllGroups(),
            TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroupScreen()),
                  );
                },
                label: const Text(
                  "Start a new group",
                  style: TextStyle(color:  const Color.fromRGBO(76, 187, 155, 1),),
                ),
                icon: const Icon(
                  Icons.group_add,
                  color:  const Color.fromRGBO(76, 187, 155, 1),
                ),
                style: TextButton.styleFrom(
                    side: const BorderSide(width: 1.0, color:  const Color.fromRGBO(76, 187, 155, 1),)))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
         //   MaterialPageRoute(builder: (context) => NewExpenseScreen(count:0)),
          );
        },
        icon: const ImageIcon(
          AssetImage("assets/expenseIcon2.jpg"),
        ),
        label: const Text("Add Expense"),
        backgroundColor:  const Color.fromRGBO(76, 187, 155, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 3) {
      // Handle Account tab tap event here
      // For example, navigate to the account screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountScreen()),
      );
    }
  }
}
