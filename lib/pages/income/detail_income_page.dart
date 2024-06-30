import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../expanse_item.dart';
import 'add_income_page.dart';

class DetailPage extends StatelessWidget {
  final String monthYear;
  final List<ExpenseItem> dailyExpenses;

  DetailPage({required this.monthYear, required this.dailyExpenses});

  @override
  Widget build(BuildContext context) {
    // Create a NumberFormat instance for Indonesian Rupiah without decimal digits
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // Separate income and outcome
    List<ExpenseItem> incomeExpenses =
    dailyExpenses.where((item) => item.type == 'income').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pemasukan Detail $monthYear'),
      ),
      body: ListView.builder(
        itemCount: incomeExpenses.length,
        itemBuilder: (context, index) {
          var expense = incomeExpenses[index];
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
              builder: (context) => AddIncomePage(monthYear: monthYear),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
