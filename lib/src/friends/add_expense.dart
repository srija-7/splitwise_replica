import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splitwise_app_replica/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({Key? key, required this.friend, required this.uid})
      : super(key: key);
  final Map<String, dynamic> friend;
  final String uid;
  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  // String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  String uid = '';
  // _AddExpenseState(this.uid);
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> friend = <String, dynamic>{};
  final DatabaseService _db = DatabaseService();
  String date = "";
  String description = '';
  int amount = 0;
  // initial values of the friend as empty map
  String _selectedDate = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _selectedDate = picked.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    friend.addAll(widget.friend);
    uid = widget.uid;
  }

  void _addDebt() {
    print(description + _selectedDate + amount.toString());
    if (description.isNotEmpty && _selectedDate.isNotEmpty && amount > 0) {
      FirebaseFirestore.instance
          .collection('friendexpenses')
          .doc(uid)
          .collection(friend['id'])
          .add({
        'desc': description,
        'date': _selectedDate,
        'amount': amount,
        'isPaid': false,
      });

      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'friend-${friend['id']}',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add expense'),
          backgroundColor: Color.fromRGBO(76, 187, 155, 1),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              // shift 10 unit left
              padding: const EdgeInsets.only(right: 10),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // const snackBar = SnackBar(
                  //   content: Text('Processing...'),
                  //   animation: null,
                  // );
                  
                    FirebaseFirestore.instance
                        .collection('friendexpenses')
                        .doc(uid)
                        .collection(friend['id'])
                        .add({
                      'desc': description,
                      'date': _selectedDate,
                      'amount': amount,
                      'isPaid': false,
                    });
                  _db.addExpense(uid, friend['id'], friend['name'],
                      friend['IOU'], description, amount);
                  Navigator.pop(context, friend);
                  
                }
              },
            ),
          ],
        ),
        body: ListView(children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Row(
                      children: [
                        Text('Paid by', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 10),
                        Container(
                          // make rounded
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.greenAccent,
                              width: 1,
                            ),
                          ),
                          child: Text(friend['name'],
                              style: TextStyle(
                                fontSize: 18,
                              )),
                        ),
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.fromLTRB(15, 0, 20, 20),
                  child:
                      Text('and split equally', style: TextStyle(fontSize: 18)),
                ),
              ]),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 40, 20),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.note_add,
                          size: 24.0,
                          semanticLabel: 'Description icon',
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                          //  controller: _descController,
                          decoration: const InputDecoration(
                            hintText: 'Enter a description',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                          autofocus: true,
                          onChanged: (val) {
                            setState(() {
                              description = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 40, 20),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.note_add,
                          size: 24.0,
                          semanticLabel: 'Description icon',
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                          readOnly: true,
                          controller:
                              TextEditingController(text: _selectedDate),
                          decoration: InputDecoration(
                            labelText: 'Date',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                _selectDate(context);
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Date';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 40, 20),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.currency_rupee,
                          size: 24.0,
                          semanticLabel: 'Rupee icon',
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter amount',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.parse(value) == 0) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              amount = int.parse(val);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
