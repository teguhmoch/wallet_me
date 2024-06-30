import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../data.dart';
import '../../expanse_item.dart';
import '../../service/auth_service.dart';
import '../../transaction_service.dart';
import 'detail_income_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IncomePage extends StatelessWidget {
  final String userId;

  const IncomePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Income Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IncomeContent(userId: userId),
    );
  }
}

class IncomeContent extends StatefulWidget {
  final String userId;

  const IncomeContent({Key? key, required this.userId}) : super(key: key);

  @override
  _IncomeContentState createState() => _IncomeContentState();
}

class _IncomeContentState extends State<IncomeContent> {
  int? selectedYear;
  bool _isLoading = true;
  List<ExpenseItem> _data = [];
  final _storage = FlutterSecureStorage();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchData(widget.userId);
  }

  Future<void> _fetchData(String userId) async {
    const String endpointUrl = 'https://ap-southeast-1.aws.data.mongodb-api.com/app/application-2-wlbrdjm/endpoint/transaction';

    try {
      final response = await http.get(
        Uri.parse('$endpointUrl?userId=$userId'),
        headers: {
          'Authorization': 'Bearer ${await _storage.read(key: 'accessToken')}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _data = data.map((item) => ExpenseItem.fromJson(item)).toList();
          _isLoading = false;
        });
        _calculateTotal();
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _calculateTotal() {
    setState(() {
      // totalAmount = _data.fold(0, (sum, item) => sum + item.amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_data);

    Map<String, int> monthlyExpenses = {};
    Map<String, List<ExpenseItem>> expensesByMonth = {};
    for (var expense in _data) {
      if (expense.type != 'income') continue;

      DateTime dateTime = DateFormat('dd-MM-yyyy').parse(expense.date);
      String monthYear = DateFormat('MM-yyyy').format(dateTime);
      if (!monthlyExpenses.containsKey(monthYear)) {
        monthlyExpenses[monthYear] = 0;
        expensesByMonth[monthYear] = [];
      }
      monthlyExpenses[monthYear] = monthlyExpenses[monthYear]! + expense.amount;
      expensesByMonth[monthYear]!.add(expense);
    }

    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    Set<int> allYears = monthlyExpenses.keys.map((date) {
      return int.parse(date.split('-')[1]);
    }).toSet();
    List<int?> yearList = [null, ...allYears.toList()];

    List<Map<String, dynamic>> filteredExpenses = selectedYear == null
        ? monthlyExpenses.entries.map((entry) => {'date': entry.key, 'total': entry.value}).toList()
        : monthlyExpenses.entries
        .where((entry) => int.parse(entry.key.split('-')[1]) == selectedYear)
        .map((entry) => {'date': entry.key, 'total': entry.value})
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pendapatan'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<int?>(
              value: selectedYear,
              onChanged: (int? newValue) {
                setState(() {
                  selectedYear = newValue;
                });
              },
              items: yearList.map((year) {
                return DropdownMenuItem<int?>(
                  value: year,
                  child: Text(year == null ? 'All Years' : year.toString()),
                );
              }).toList(),
            ),
          ),
          // Text('Total Amount: ${formatCurrency.format(totalAmount)}'),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredExpenses.length,
              itemBuilder: (context, index) {
                var expense = filteredExpenses[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          monthYear: expense['date'],
                          dailyExpenses: expensesByMonth[expense['date']]!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Icon(Icons.money),
                      title: Text('Date: ${expense['date']}'),
                      trailing: Text(
                        'Total: ${formatCurrency.format(expense['total'])}',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
