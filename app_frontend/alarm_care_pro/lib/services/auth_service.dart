import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String _baseUrl = "http://localhost:8000";
  final _storage = const FlutterSecureStorage();

  Future<String?> get token async {
    return await _storage.read(key: 'access_token');
  }

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/auth/token');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _storage.write(key: 'access_token', value: data['access_token']);
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }

  Future<bool> register(String email, String username, String password, String? fullName) async {
    final url = Uri.parse('$_baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'username': username,
        'password': password,
        'full_name': fullName,
      }),
    );

    return response.statusCode == 200;
  }
}
