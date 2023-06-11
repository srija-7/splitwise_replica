import 'package:flutter/material.dart';

class AddFriendScreen extends StatefulWidget {
  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final _friendNameController = TextEditingController();

  void _addFriend() {
    // Add friend to the list
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _friendNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friend'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _friendNameController,
              decoration: InputDecoration(
                labelText: 'Friend Name',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Add Friend'),
              onPressed: () {
                _addFriend();
              },
            ),
          ],
        ),
      ),
    );
  }
}
