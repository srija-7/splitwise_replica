import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:splitwise_app_replica/constants.dart';
import 'package:splitwise_app_replica/src/account_page.dart';
import 'package:splitwise_app_replica/src/groups/groups_home_page.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app_replica/src/friends/friends.dart';
import 'package:splitwise_app_replica/src/activity_page.dart';
// import 'package:splitwise_app_replica/src/debt_management.dart';
import 'package:splitwise_app_replica/Expenses/expenses.dart';

class MainPage extends StatefulWidget {
  final String uid;
  MainPage({required this.uid});
  final String title = 's';
  final screens = [
    const GroupsPage(),
    
    const FriendsPage(),
    ExpenseManagementScreen(),
    const AccountPage(),
  ];
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  String _title = 'Your Groups';
  final List<Widget> _screens = [
    const GroupsPage(),
    
    const FriendsPage(),
    ExpenseManagementScreen(),
    const AccountPage(),
  ];
  // @override
  // initState(){
  //   _title = 'Some default value';
  // }
  @override
  Widget build(BuildContext context) {
    const bgcolor = Color.fromARGB(255, 93, 255, 228);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_title),
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //       color: Color.fromARGB(255, 35, 34, 34),
      //     ),
      //   ),
      // ),
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: GNav(
        color: Colors.black,
        // tabBackgroundColor: colorTheme,
        activeColor: colorTheme,
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
            switch (index) {
              case 0:
                {
                  _title = 'Your Groups';
                }
                break;
              case 2:
                {
                  _title = 'Recent Activity';
                }
                break;
              case 1:
                {
                  _title = 'Your Friends';
                }
                break;
              case 3:
                {
                  _title = 'Your Profile';
                }
                break;
            }
          });
        },
        selectedIndex: _currentIndex,
        tabs: const [
          GButton(
            icon: Icons.group,
            text: "Groups",
          ),GButton(
            icon: Icons.person,
            text: "Friends",
          ),
          GButton(
            icon: Icons.show_chart,
            text: "Expense",
          ),
          GButton(
            icon: Icons.account_box,
            text: "Account"
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   fixedColor: Colors.white,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.group, color: bgcolor),
      //       label: 'Groups',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home, color: bgcolor),
      //       label: 'Activity',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person, color: bgcolor),
      //       label: 'Friends',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle_rounded, color: bgcolor),
      //       label: 'Account',
      //     ),
      //   ],
      //   onTap: (int index) {
      //     setState(() {
      //       _currentIndex = index;
      //       switch (index) {
      //         case 0:
      //           {
      //             _title = 'Your Groups';
      //           }
      //           break;
      //         case 1:
      //           {
      //             _title = 'Recent Activity';
      //           }
      //           break;
      //         case 2:
      //           {
      //             _title = 'Your Friends';
      //           }
      //           break;
      //         case 3:
      //           {
      //             _title = 'Your Profile';
      //           }
      //           break;
      //       }
      //     });
      //   },
      // ),
    );
  }
}
