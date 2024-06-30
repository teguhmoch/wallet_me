// import 'package:flutter/material.dart';
// // import 'package:myapp/expanse_item.dart';
// // import 'package:myapp/screens.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../data.dart';
// import '../../expanse_item.dart';
// import '../../service/auth_service.dart';
// // import 'package:myapp/data.dart';
//
//
//
// class HistoryPage extends StatelessWidget {
//   const HistoryPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'History Page',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),home: HistoryContent(),
//     );
//   }
// }
//
// class HistoryContent extends StatefulWidget {
//
// // Suggested code may be subject to a license. Learn more: ~LicenseLog:81588597.
//   @override
//   _HistoryContentState createState() => _HistoryContentState();
// }
//
//
// class _HistoryContentState extends State<HistoryContent> {
//
//   late int totalAmount ;
//   bool _isLoading = true;
//   final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0,
//   );
//   List<ExpenseItem> _data = [];
//   final String _email = 'teguhmochammad722@gmail.com'; // Replace with your test user email
//   final String _password = 'Dodol!04'; // Replace with your test user password
//   final AuthService _authService = AuthService();
//
//
//   @override
//   void initState() {
//     super.initState();
//     _authenticateAndFetchData();
//     totalAmount = globalData.fold(0, (sum, item) => sum + item.amount); // Calculate here
//   }
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
//           _calculateTotal();
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
//   void _calculateTotal() {
//     setState(() {
//       totalAmount = _data.fold(0, (sum, item) => item.type == 'income' ? sum + item.amount : sum);
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('History'),
//           centerTitle: true,
//           backgroundColor: Colors.cyan,
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Total Amount: ${formatCurrency.format(totalAmount)}',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _data.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     margin: EdgeInsets.all(10),
//                     child: ListTile(
//                       leading: Icon(Icons.money),
//                       title: Text(_data[index].name),
//                       subtitle: Text('Date: ${_data[index].date}'),
//                       trailing: Text('Amount: ${formatCurrency.format(_data[index].amount)}'),
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
