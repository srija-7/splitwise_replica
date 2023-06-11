import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
// import 'package:paytm/paytm.dart';
import 'package:upi_india/upi_india.dart';
import 'package:splitwise_app_replica/Expenses/upiPayment.dart';

class DebtManagementScreen extends StatefulWidget {
  @override
  State<DebtManagementScreen> createState() => _DebtManagementScreenState();
}

class _DebtManagementScreenState extends State<DebtManagementScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debt Management'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('debts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final debts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: debts.length,
            itemBuilder: (context, index) {
              final debt = debts[index];
              final debtor = debt['debtor'];
              final creditor = debt['creditor'];
              final amount = debt['amount'];
              final isPaid = debt['isPaid'];

              return ListTile(
                title: Text('$debtor owes $creditor $amount'),
                subtitle: isPaid ? const Text('Paid') : const Text('Not Paid'),
                trailing: isPaid
                    ? null
                    : ElevatedButton(
                        onPressed: () => _settleDebt(debt.reference),
                        child: const Text('Settle'),
                      ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addDebt(context),
        child: const Icon(Icons.add),
      ),
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
//       context,
//       MaterialPageRoute(builder: (context) => UPIpaymen()),
//     );
   
}
}

class AddDebtScreen extends StatefulWidget {
  @override
  _AddDebtScreenState createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  final TextEditingController _debtorController = TextEditingController();
  final TextEditingController _creditorController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _addDebt() {
    final debtor = _debtorController.text;
    final creditor = _creditorController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (debtor.isNotEmpty && creditor.isNotEmpty && amount > 0) {
      FirebaseFirestore.instance.collection('debts').add({
        'debtor': debtor,
        'creditor': creditor,
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
        title: const Text('Add Debt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _debtorController,
              decoration: const InputDecoration(hintText: 'Debtor'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _creditorController,
              decoration: const InputDecoration(hintText: 'Creditor'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Amount'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addDebt,
              child: const Text('Add Debt'),
            ),
          ],
        ),
      ),
    );
  }
}
