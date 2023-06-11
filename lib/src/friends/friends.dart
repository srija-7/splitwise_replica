import 'package:splitwise_app_replica/constants.dart';
import 'package:splitwise_app_replica/services/database.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app_replica/src/friends/add_expense.dart';
import 'package:splitwise_app_replica/src/friends/add_friend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splitwise_app_replica/Expenses/upiPayment.dart';
import 'package:splitwise_app_replica/src/friends/friend_activity.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseService()
          .getFriendsOfAUser(FirebaseAuth.instance.currentUser?.uid ?? ''),
      builder: ((BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting) {
          return FriendsBuild(allfriends: snapshot.data ?? []);
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}

class FriendsBuild extends StatefulWidget {
  const FriendsBuild({Key? key, required this.allfriends}) : super(key: key);

  final List<Map<String, dynamic>> allfriends;
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsBuild> {
  final List<Map<String, dynamic>> _allfriends = [];
  List<Map<String, dynamic>> _foundUsers = [];
  String stat = "";
  @override
  initState() {
    // at the beginning, all users are shown
    _allfriends.addAll(widget.allfriends);
    _foundUsers = _allfriends;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allfriends;
    } else {
      results = _allfriends
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: _allfriends.isEmpty
              ? <Widget>[
                  SizedBox(height: 20),
                  Center(
                      child: Text('Add a friend to start',
                          style: TextStyle(fontSize: 24))),
                ]
              : [
                  TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: colorTheme,
                              width: 2.0
                          )
                      ),
                      labelText: 'Search',
                      suffixIcon: Icon(Icons.search),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      suffixIconColor: colorTheme,
                      iconColor: Colors.grey
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: _foundUsers.isNotEmpty
                        ? ListView.builder(
                            itemCount: _foundUsers.length,
                            itemBuilder: (context, index) =>
                                buildBox(_foundUsers[index]),
                          )
                        : const Text(
                            'No results found',
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-friend',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFriend()),
          );
        },
        // Add your onPressed code here!
        label: const Text('Add Friend '),
        icon: const Icon(Icons.person_add),
        backgroundColor: Color.fromRGBO(76, 187, 155, 1),
      ),
    );
  }

  Widget buildBox(Map<String, dynamic> friend) => Hero(
        tag: 'friend-${friend['id']}',
        child: Container(
          height: 85,
          width: 60,
          // alignment: Alignment.center,
          child: Card(
            key: ValueKey(friend["id"]),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 1),
            child: ListTile(
              visualDensity: VisualDensity.comfortable,
              // increase size of this icon
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.asset(
                  "assets/pf.png"
                ),
              ),
              title: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  friend['name'],
                  style: const TextStyle(
                    fontSize: 19,
                    color: colorTheme
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendActivity(friend: friend)),
                );
              },
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    friend['IOU'] == 0
                        ? 'settled'
                        : friend['IOU'] > 0
                            ? 'owes you'
                            : 'you owe',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      color: friend['IOU'] == 0
                          ? Colors.grey
                          : friend['IOU'] > 0
                              ? Colors.greenAccent
                              : const Color.fromARGB(255, 255, 107, 97),
                    ),
                  ),
                  Text(
                    friend['IOU'] == 0
                        ? ''
                        : friend['IOU'] > 0
                            ? ' ${friend['IOU']}'
                            : ' ${-friend['IOU']}',
                    style: TextStyle(
                      // make the text bold and big
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: friend['IOU'] == 0
                          ? Colors.black
                          : friend['IOU'] > 0
                              ? Colors.greenAccent
                              : const Color.fromARGB(255, 255, 107, 97),
                    ),
                  ),
                      // ElevatedButton(
                      //   style: ButtonStyle(
                      //     minimumSize:  MaterialStateProperty.all<Size>(
                      //               Size(1,1),
                      //               ),
                      //     backgroundColor: MaterialStateProperty.all<Color>(
                      //       Color.fromRGBO(76, 187, 155, 1),
                      //     ),
                      //   ),
                      //   onPressed: () async {
                      //     final status = await Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => UPIpayment()),
                      //     );
                      //     print(status);
                      //     int temp = friend['IOU'];
                      //     if (status) {
                      //       temp = 0;
                      //     }

                      //     setState(() {
                      //       friend['IOU'] = temp;
                      //     });
                       // },
                      //   child: Text(
                      //     'Pay',
                      //     style:
                      //         TextStyle(color: Color.fromARGB(76, 187, 155, 1)),
                      //   ),
                      // ),

                ],
              ),
            ),
          ),
        ),
      );
}
