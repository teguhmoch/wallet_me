import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../expanse_item.dart';
import 'add_outcome_page.dart';

class OutcomeDetailPage extends StatelessWidget {
  final String monthYear;
  final List<ExpenseItem> dailyExpenses;

  OutcomeDetailPage({required this.monthYear, required this.dailyExpenses});

  @override
  Widget build(BuildContext context) {
    // Create a NumberFormat instance for Indonesian Rupiah without decimal digits
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // Separate income and outcome
    List<ExpenseItem> outcomeExpenses =
    dailyExpenses.where((item) => item.type == 'outcome').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengeluaran Detail $monthYear'),
      ),
      body: ListView.builder(
        itemCount: outcomeExpenses.length,
        itemBuilder: (context, index) {
          var expense = outcomeExpenses[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.money),
              title: Text(expense.name),
              subtitle: Text('Date: ${expense.date}'),
              trailing: Text(
                'Amount: ${formatCurrency.format(expense.amount)}',
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddOutcomePage(monthYear: monthYear),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
