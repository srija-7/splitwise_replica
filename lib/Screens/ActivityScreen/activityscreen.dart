import 'package:flutter/material.dart';

class Expense {
  final String name;
  final double amount;
  final DateTime date;

  Expense({required this.name, required this.amount, required this.date});
}

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final List<Expense> _expenses = [
    Expense(name: 'Groceries', amount: 30.0, date: DateTime.now()),
    Expense(name: 'Gas', amount: 50.0, date: DateTime.now().subtract(Duration(days: 1))),
    Expense(name: 'Dinner', amount: 75.0, date: DateTime.now().subtract(Duration(days: 2))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
      ),
      body: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (BuildContext context, int index) {
          final expense = _expenses[index];
          return ListTile(
            title: Text(expense.name),
            subtitle: Text('Amount: ${expense.amount}'),
            trailing: Text('${expense.date.day}/${expense.date.month}/${expense.date.year}'),
          );
        },
      ),
    );
  }
}
