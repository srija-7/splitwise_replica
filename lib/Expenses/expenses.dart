

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitwise_app_replica/Expenses/upiPayment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splitwise_app_replica/services/auth.dart';


class ExpenseManagementScreen extends StatefulWidget {
  @override
  State<ExpenseManagementScreen> createState() => _ExpenseManagementScreenState();
}

class _ExpenseManagementScreenState extends State<ExpenseManagementScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Management'),
        backgroundColor: Color.fromRGBO(76, 187, 155, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('expenses').doc(uid).collection('expense').snapshots(),
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
                title: Text('You added an expense for "$desc" on [$date] : Rs. $amount'),
                subtitle: isPaid ? Text('Paid') : Text('Not Paid'),
                trailing: isPaid
                    ? null
                    : ElevatedButton(
                       style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color.fromRGBO(76, 187, 155, 1),
                                    ),
                                  ),
                        onPressed: () => _settleDebt(debt.reference),
                        child: Text('Already Paid?',
                      //  style: TextStyle(color: Color.fromARGB(76, 187, 155, 1)),
                        ),
                      ),
              );
            },
          );
        },
      ),
     floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addDebt(context),
       // child: Icon(Icons.add),
         icon: const ImageIcon(
          AssetImage("assets/expenseIcon2.jpg"),
        ),
        label: const Text("Add Expense"),
        backgroundColor:  const Color.fromRGBO(76, 187, 155, 1),
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _addDebt(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDebtScreen()),
    );
  }

  void _settleDebt(DocumentReference debtRef) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => UPIpayment()),
    // );
   
    debtRef.update({'isPaid': true});
  }
}

class AddDebtScreen extends StatefulWidget {
  @override
  _AddDebtScreenState createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  void _addDebt() {
    final desc = _descController.text;
    final date = _dateController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (desc.isNotEmpty && date.isNotEmpty && amount > 0) {
      FirebaseFirestore.instance.collection('expenses').doc(uid).collection('expense').add({
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
                        minimumSize:  MaterialStateProperty.all<Size>(
                                    Size(50,50),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
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