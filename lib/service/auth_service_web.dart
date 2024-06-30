import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String realmAppId = 'application-2-wlbrdjm';
  final String baseUrl = 'https://realm.mongodb.com/api/client/v2.0/app/$realmAppId';
  final String loginUrl = 'https://realm.mongodb.com/api/client/v2.0/app/$realmAppId/auth/providers/local-userpass/login';


  Future<Map<String, String>?> authenticate(String email, String password) async {
    final loginResponse = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (loginResponse.statusCode == 200) {
      final loginData = json.decode(loginResponse.body);
      final String accessToken = loginData['access_token'];
      final String userId = loginData['user_id'];
      print('AccessToken: $accessToken, UserId: $userId'); // Add this line
      return {'accessToken': accessToken, 'userId': userId};
    } else {
      print('Authentication failed: ${loginResponse.body}');
      return null;
    }
  }


  Future<bool> register(String email, String password) async {
    final registerUrl = '$baseUrl/auth/providers/local-userpass/register';
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Registration failed: ${response.body}');
      return false;
    }
  }
}


