import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitwise_app_replica/Expenses/upiPayment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splitwise_app_replica/services/auth.dart';
import 'package:splitwise_app_replica/services/database.dart';
import 'package:splitwise_app_replica/src/friends/add_expense.dart';

class FriendActivity extends StatefulWidget {
  const FriendActivity({Key? key, required this.friend}) : super(key: key);
  final Map<String, dynamic> friend;
  @override
  State<FriendActivity> createState() => _FriendActivityState();
}

class _FriendActivityState extends State<FriendActivity> {
  final Map<String, dynamic> friend = <String, dynamic>{};
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    friend.addAll(widget.friend);
    print(friend['name']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity with  ${friend['name']} '),
        backgroundColor: Color.fromRGBO(76, 187, 155, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('friendexpenses')
            .doc(uid)
            .collection(friend['id'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final debts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: debts.length,
            itemBuilder: (context, index) {
              final debt = debts[index];
              final desc = debt['desc'];
              final date = debt['date'];
              final amount = debt['amount'];
              final isPaid = debt['isPaid'];

              return ListTile(
                title: Text(
                    ' ${friend['name']} paid for "$desc" on [$date] : Rs. $amount'),
                subtitle: isPaid ? Text('Paid') : Text('Not Paid'),
                trailing: isPaid
                    ? null
                    : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(76, 187, 155, 1),
                          ),
                        ),
                        onPressed: () => _settleDebt(debt.reference, amount),
                        child: Text(
                          'Pay',
                          //  style: TextStyle(color: Color.fromARGB(76, 187, 155, 1)),
                        ),
                      ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddExpense(friend: friend, uid: uid)),
        ),

        // child: Icon(Icons.add),
        icon: const ImageIcon(
          AssetImage("assets/expenseIcon2.jpg"),
        ),
        label: const Text("Add Expense"),
        backgroundColor: const Color.fromRGBO(76, 187, 155, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _addDebt(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddDebtScreen(
                friend: friend,
              )),
    );
  }

  void _settleDebt(DocumentReference debtRef, int amount) async {
    DocumentSnapshot snapshot = await debtRef.get();
    String desc = snapshot['desc'];
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UPIpayment(
                friend: friend,
                amount: amount,
                onPaymentCompleted: (bool isPaymentSuccessful) {
                  if (isPaymentSuccessful) {
                    debtRef.update({'isPaid': true});
                    _db.addExpense(uid, friend['id'], friend['name'],
                        friend['IOU'], desc, -amount);
                  }
                },
              )),
    );
  }
}

class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen({
    Key? key,
    required this.friend,
  }) : super(key: key);
  final Map<String, dynamic> friend;
  @override
  _AddDebtScreenState createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  final Map<String, dynamic> friend = <String, dynamic>{};

  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  @override
  void initState() {
    super.initState();
    friend.addAll(widget.friend);
  }

  void _addDebt() {
    final desc = _descController.text;
    final date = _dateController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (desc.isNotEmpty && date.isNotEmpty && amount > 0) {
      FirebaseFirestore.instance
          .collection('friendexpenses')
          .doc(uid)
          .collection(friend['id'])
          .add({
        'desc': desc,
        'date': date,
        'amount': amount,
        'isPaid': false,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add an Expense'),
        backgroundColor: Color.fromRGBO(76, 187, 155, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descController,
              decoration: InputDecoration(hintText: 'Description'),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(hintText: 'Date (dd-mm-yyyy)'),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Amount'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(50, 50),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(76, 187, 155, 1),
                ),
              ),
              onPressed: _addDebt,
              child: Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
