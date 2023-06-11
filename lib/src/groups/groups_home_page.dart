import 'package:splitwise_app_replica/constants.dart';
import 'package:splitwise_app_replica/services/database.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app_replica/src/groups/create_group_addfriends.dart';
import 'group_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseService()
            .getGroupsOfAUser(FirebaseAuth.instance.currentUser?.uid ?? ''),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return BuildPage(allgroups: snapshot.data ?? []);
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class BuildPage extends StatefulWidget {
  const BuildPage({Key? key, required this.allgroups}) : super(key: key);

  final List<Map<String, dynamic>> allgroups;

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<BuildPage> {
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  bool loading = true;
  List<Map<String, dynamic>> _foundGroups = [];

  @override
  initState() {
    // at the beginning, all users are shown
    _foundGroups = widget.allgroups;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = widget.allgroups;
    } else {
      results = widget.allgroups
          .where((user) =>
          user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundGroups = (results);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: widget.allgroups.isEmpty
              ? [
                  const SizedBox(height: 20),
                  const Center(
                      child: Text('Create a group to start',
                          style: TextStyle(fontSize: 24))),
                ]
              : [
                  TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: const InputDecoration(
                      labelText: 'Search', suffixIcon: Icon(Icons.search),
                        focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: colorTheme,
                          width: 2.0
                        )
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusColor: colorTheme
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: _foundGroups.isNotEmpty
                        ? ListView.builder(
                            itemCount: _foundGroups.length,
                            itemBuilder: (context, index) =>
                                buildBox(_foundGroups[index]),
                          )
                        : const Text(
                            'No results found',
                            style: TextStyle(fontSize: 24),
                          ),
                  ),
                ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'createGroup',
        backgroundColor: Color.fromRGBO(76,187,155,1),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGroupPage()),
          );
        },
        // Add your onPressed code here!
        label: const Text('Create Group'),
        icon: const Icon(Icons.group_add),
      ),
    );
  }

  Widget buildBox(Map<String, dynamic> group) => Hero(
        tag: 'group-${group['id']}',
        child: SizedBox(
          height: 90,
          child: Card(
            key: ValueKey(group["id"]),
            elevation: 0,
            // margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              visualDensity: VisualDensity.comfortable,
              leading: ClipRRect(borderRadius: BorderRadius.circular(5.0), child: Image.asset("assets/groupicon.jpg")),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Group(group: group)),
                );
              },
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 13),
                  Text('${group['name']}', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
}

