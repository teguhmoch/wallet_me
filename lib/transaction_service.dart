import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {
  static const String _baseUrl = 'https://ap-southeast-1.aws.data.mongodb-api.com/app/application-2-wlbrdjm/endpoint/transaction';

  Future<List<Map<String, dynamic>>> fetchTransaction() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
