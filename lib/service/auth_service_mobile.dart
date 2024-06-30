import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String realmAppId = 'application-2-wlbrdjm';
  // final String loginUrl = 'https://realm.mongodb.com/api/client/v2.0/app/$realmAppId/auth/providers/local-userpass/login';
  final String baseUrl = 'https://realm.mongodb.com/api/client/v2.0/app/$realmAppId';
  final _storage = FlutterSecureStorage();

  Future<String?> authenticate(String email, String password) async {
    final loginUrl = '$baseUrl/auth/providers/local-userpass/login';
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      final String accessToken = data['access_token'];
      final String userId = data['user_id'];
      await _storage.write(key: 'accessToken', value: accessToken);
      await _storage.write(key: 'userId', value: userId);
      return accessToken;
    } else {
      print('Authentication failed: ${response.body}');
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

  Future<String?> getStoredToken() async {
    return await _storage.read(key: 'accessToken');
  }
}



