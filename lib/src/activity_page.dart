import 'package:flutter/material.dart';
import 'package:splitwise_app_replica/src/friends/friends.dart';
import 'package:splitwise_app_replica/Expenses/expenses.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int count = 1;
  List<Map<String, dynamic>> _activity = [];

  @override
  void initState() {
    super.initState();
    _updateActivityList();
  }

  void _updateActivityList() {
    _activity = List.generate(count, (index) {
      return {
        'id': index,
        'sender': '${index + 1} You',
        'receiver': 'Friend ${2 * index + 2}',
        'desc': 'something #${index + 1}',
        'amount': 100 * index + 100,
        'time': DateTime.now(),
      };
    });
  }

  void _navigateToOtherScreen() async {
    final result = await Navigator.pushNamed(
      context,
      '/expense',
      arguments: {'count': count, 'desc': "hi", 'amount': "hello"},
    );
    if (result != null) {
      Map<String, dynamic> resultMap = result as Map<String, dynamic>;
      setState(() {
        count = resultMap['count'];
        print(count);
        _activity[count-1]['desc'] = resultMap['desc'];
        _activity[count-1]['amount'] = resultMap['amount'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: _activity.isNotEmpty
                  ? ListView.builder(
                      itemCount: _activity.length,
                      itemBuilder: (context, index) =>
                          buildBox(_activity[index]),
                    )
                  : const Text(
                      'Nothing to see here...',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToOtherScreen,
        icon: const ImageIcon(
          AssetImage("assets/expenseIcon2.jpg"),
        ),
        label: const Text("Add Expense"),
        backgroundColor: const Color.fromRGBO(76, 187, 155, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Widget buildBox(Map<String, dynamic> activity) => SizedBox(
      height: 110,
      child: Card(
        key: ValueKey(activity["id"]),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          onTap: () {},
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              Text(
                  '${activity['sender']} added expense ${activity['amount']} Rs to ${activity['receiver']} for ${activity['desc']}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text(
                '${activity['time']}'.substring(0, 10),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
