// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../../expanse_item.dart';
// import '../../service/auth_service.dart';
// import '../../data.dart';
// import 'detail_outcome_page.dart';
//
//
// class OutcomePage extends StatelessWidget {
//   const OutcomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Outcome Page',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),home: OutcomeContent(),
//     );
//   }
// }
//
// class OutcomeContent extends StatefulWidget {
//
// // Suggested code may be subject to a license. Learn more: ~LicenseLog:81588597.
//   @override
//   _OutcomeContentState createState() => _OutcomeContentState();
// }
//
//
// class _OutcomeContentState extends State<OutcomeContent> {
//
//   int? selectedYear;
//   bool _isLoading = true;
//   List<ExpenseItem> _data = [];
//   final String _email = 'teguhmochammad722@gmail.com'; // Replace with your test user email
//   final String _password = 'Dodol!04'; // Replace with your test user password
//   final AuthService _authService = AuthService();
//
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     _authenticateAndFetchData();
//     // totalAmount = expenses.fold(0, (sum, item) => sum + item.amount); // Calculate here
//   }
//
//
//   Future<void> _authenticateAndFetchData() async {
//     try {
//       final accessToken = await _authService.authenticate(_email, _password);
//       if (accessToken != null) {
//         await _fetchData(accessToken);
//       } else {
//         print('Authentication failed');
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _fetchData(String accessToken) async {
//     const String endpointUrl = 'https://ap-southeast-1.aws.data.mongodb-api.com/app/application-2-wlbrdjm/endpoint/transaction';
//
//     try {
//       final response = await http.get(
//         Uri.parse(endpointUrl),
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _data = data.map((json) => ExpenseItem.fromJson(json)).toList();
//           _isLoading = false;
//         });
//       } else {
//         print('Error response: ${response.body}');
//         throw Exception('Failed to load data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Failed to fetch data: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     // Transform the data
//     Map<String, int> monthlyExpenses = {};
//     Map<String, List<ExpenseItem>> expensesByMonth = {};
//     for (var expense in _data) {
//       if (expense.type != 'outcome') continue; // Filter to include only income
//
//       DateTime dateTime = DateFormat('dd-MM-yyyy').parse(expense.date);
//       String monthYear = DateFormat('MM-yyyy').format(dateTime);
//       if (!monthlyExpenses.containsKey(monthYear)) {
//         monthlyExpenses[monthYear] = 0;
//         expensesByMonth[monthYear] = [];
//       }
//       monthlyExpenses[monthYear] = monthlyExpenses[monthYear]! + expense.amount;
//       expensesByMonth[monthYear]!.add(expense);
//     }
//
//     // Create a NumberFormat instance for Indonesian Rupiah without decimal digits
//     final formatCurrency = NumberFormat.currency(
//       locale: 'id_ID',
//       symbol: 'Rp',
//       decimalDigits: 0,
//     );
//
//     // Extract all unique years from monthly expenses for filtering
//     Set<int> allYears = monthlyExpenses.keys.map((date) {
//       return int.parse(date.split('-')[1]);
//     }).toSet();
//     List<int?> yearList = [null, ...allYears.toList()];
//
//     // Filter the expenses by selected year
//     List<Map<String, dynamic>> filteredExpenses = selectedYear == null
//         ? monthlyExpenses.entries.map((entry) => {'date': entry.key, 'total': entry.value}).toList()
//         : monthlyExpenses.entries
//         .where((entry) => int.parse(entry.key.split('-')[1]) == selectedYear)
//         .map((entry) => {'date': entry.key, 'total': entry.value})
//         .toList();
//
//     // TODO: implement build
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Pengeluaran'),
//           centerTitle: true,
//           backgroundColor: Colors.cyan,
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: DropdownButton<int?>(
//                 value: selectedYear,
//                 onChanged: (int? newValue) {
//                   setState(() {
//                     selectedYear = newValue;
//                   });
//                 },
//                 items: yearList.map((year) {
//                   return DropdownMenuItem<int?>(
//                     value: year,
//                     child: Text(year == null ? 'All Years' : year.toString()),
//                   );
//                 }).toList(),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: filteredExpenses.length,
//                 itemBuilder: (context, index) {
//                   var expense = filteredExpenses[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => OutcomeDetailPage(
//                             monthYear: expense['date'],
//                             dailyExpenses: expensesByMonth[expense['date']]!,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       margin: EdgeInsets.all(10),
//                       child: ListTile(
//                         leading: Icon(Icons.money),
//                         title: Text('Date: ${expense['date']}'),
//                         trailing: Text(
//                           'Total: ${formatCurrency.format(expense['total'])}',
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],)
//     );
//   }
//
// }
