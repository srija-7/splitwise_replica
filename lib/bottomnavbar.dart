
import 'package:flutter/material.dart';
import 'package:splitwise_app_replica/Screens/GroupScreens/group_page.dart';
import 'package:splitwise_app_replica/Screens/FriendsScreen/addfriend.dart';
import 'package:splitwise_app_replica/Screens/Authentication/account.dart';
import 'package:splitwise_app_replica/Screens/ActivityScreen/activityscreen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  BottomNavBar({required this.currentIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.group, color: Colors.black),
          label: "Groups",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people, color:Colors.black),
          label: "Friends",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline, color:Colors.black,),
          label: "Activity",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, color:Colors.black),
          label: "Account",
        ),
      ],
      selectedItemColor:  const Color.fromRGBO(76, 187, 155, 1),
      unselectedItemColor: Color.fromARGB(255, 26, 25, 25),
      selectedLabelStyle: const TextStyle(color:  const Color.fromRGBO(76, 187, 155, 1)),
      unselectedLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 19, 19, 19),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _children = [    GroupScreen(),    AddFriendScreen(),    ActivityScreen(),    AccountScreen(),  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => _children[_currentIndex]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}
