import 'package:flutter/material.dart';
import 'package:splitwise_app_replica/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_contribution.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
Future<Map<String, dynamic>> getVals(
    Map<String, dynamic> group, String uid) async {
  Map<String, dynamic> vals = {};
  vals['allfriends'] =
      await DatabaseService().getUsersOfAGroup(group['id'] ?? '');
  vals['ts'] = await DatabaseService().getTsOfAGroup(group['id'] ?? '', uid);
  //vals['token'] = await DatabaseService().getUserToken(group['id'] ?? '', uid);
  return vals;
}


class Group extends StatelessWidget {
  const Group({Key? key, required this.group}) : super(key: key);
  final Map<String, dynamic> group;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getVals(group, FirebaseAuth.instance.currentUser!.uid),
      builder: ((BuildContext context,
          AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting) {
          return GroupsBuild(
              group: group,
              allfriends: snapshot.data?['allfriends'],
              ts: snapshot.data?['ts']);
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}

class GroupsBuild extends StatefulWidget {
  const GroupsBuild(
      {Key? key,
      required this.group,
      required this.allfriends,
      required this.ts})
      : super(key: key);
  final Map<String, dynamic> group;
  final Map<String, dynamic> ts;
  final List<Map<String, dynamic>> allfriends;

  @override
  State<GroupsBuild> createState() => _GroupState();
}

class _GroupState extends State<GroupsBuild> {
  // CONNECTED USERS STUFF --------------------

  List<Map<String, dynamic>> cnu = [];
  final Map<String, dynamic> mapping = {};
  // GROUP MEMBERS STUFF ----------------------
  List<Map<String, dynamic>> groupMembers = [];
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> group = <String, dynamic>{};
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  // initial values of the friend as empty map
  @override
  void initState() {
    mapping.addAll(widget.ts);

    cnu = widget.ts['connected_users'];
    groupMembers.addAll(widget.allfriends);
    print(groupMembers.toString());
    print(cnu.toString());
    print(mapping.toString());
    group.addAll(widget.group);
    // CONNECTED USERS --------------
    _firebaseMessaging.requestPermission();

    super.initState();
  }

  static const headingStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w500);
  static const textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Got a message: ${message.notification?.body}');
});

    return Hero(
      tag: 'group-${group['id']}',
      child: Scaffold(
        appBar: AppBar(
          title: Text('${group['name']}'),
          backgroundColor: Color.fromRGBO(76, 187, 155, 1),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: groupMembers.length + cnu.length + 2,
                    itemBuilder: (context, index) {
                      print(groupMembers.length + cnu.length + 2);
                      return index == 0
                          ? buildHeading1()
                          : index == cnu.length + 1
                              ? buildHeading2()
                              : index < cnu.length + 1
                                  ? buildConnectedUser(index - 1)
                                  : index < groupMembers.length + cnu.length + 2
                                      ? buildMember(index - cnu.length - 2)
                                      : SizedBox(
                                          height: 10,
                                        );
                               
     }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromRGBO(76, 187, 155, 1),
          heroTag: null,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddContribution(
                    group: group,
                  ),
                ));
          },
          // Add your onPressed code here!
          label: const Text('Add Contribution'),
          icon: const Icon(Icons.person_add),
        ),
      ),
    );
  }

  buildHeading1() => Padding(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: mapping['get_back']
          ? (const Text('Get back from ', style: headingStyle))
          : (const Text('You owe ', style: headingStyle)));

  buildHeading2() => const Padding(
      padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
      child: Text('Members and Contributions', style: headingStyle));
// buildConnectedUser(int index) =>Card(
   
// if(mapping['connected_users'][index]['amount'] > 0) {
//     String token = mapping['connected_users'][index]['token'];
//     String message =
//         'You owe ${mapping['connected_users'][index]['friend_name']} ${mapping['connected_users'][index]['amount']}';
//     _firebaseMessaging.send(
//         to: token,
//         notification: Notification(
//             title: 'Splitwise', body: message),
//         data: {'message': message});
//         },
//         );
//   // {
//   // if (mapping['connected_users'][index]['amount'] > 0) {
//   //   String token = mapping['connected_users'][index]['token'];
//   //   String message =
//   //       'You owe ${mapping['connected_users'][index]['friend_name']} ${mapping['connected_users'][index]['amount']}';
//   //   _firebaseMessaging.send(
//   //       to: token,
//   //       notification: Notification(
//   //           title: 'Splitwise', body: message),
//   //       data: {'message': message});
//   // }

//   buildMember(int index) => Card(
//     key: ValueKey(mapping['connected_users'][index]['name']),
//     elevation: 2,
//     child: ListTile(
//       title: Text(
//         mapping['connected_users'][index]['friend_name'],
//         style: textStyle,
//       ),
//       trailing: Text(
//         '${mapping['connected_users'][index]['amount']}',
//         style: textStyle,
//       ),
//     ),
//   );
//  buildConnectedUser(int index) async {
//   if (mapping['connected_users'][index]['amount'] > 0) {
//     String token = mapping['connected_users'][index]['token'];
//     String message = 'You owe ${mapping['connected_users'][index]['friend_name']} ${mapping['connected_users'][index]['amount']}';
//   await   _firebaseMessaging.sendMessage(
//       to: token,
//     //title: 'Splitwise', body: message,
//       data: {'message': message},
//     );
//   }
//   return Card();
// }

//  buildMember(int index) {
//   return Card(
//     key: ValueKey(mapping['connected_users'][index]['name']),
//     elevation: 2,
//     child: ListTile(
//       title: Text(
//         mapping['connected_users'][index]['friend_name'],
//         style: textStyle,
//       ),
//       trailing: Text(
//         '${mapping['connected_users'][index]['amount']}',
//         style: textStyle,
//       ),
//     ),
//   );
// }

// }


  buildConnectedUser(int index) => Card(
      key: ValueKey(mapping['connected_users'][index]['name']),
      child: ListTile(
        leading: Image.asset("assets/expenseIcon3.png", height: 50.0,),
        title: Text(
          mapping['connected_users'][index]['friend_name'],
          style: textStyle,
        ),
        trailing: Text(
          '${mapping['connected_users'][index]['amount']}',
          style: textStyle,
        ),
      ));
  buildMember(int index) => Card(
        key: ValueKey(groupMembers[index]['uid']),
        child: ListTile(
          leading: ClipRRect(borderRadius: BorderRadius.circular(25.0), child: Image.asset("assets/pf.png", height: 50.0, fit: BoxFit.fill,)),
          title: Text(
            groupMembers[index]['name'],
            style: textStyle,
          ),
          trailing: Text(
            '${groupMembers[index]['contribution']}',
            style: textStyle,
          ),
        ),
      );
}
