import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  static const String baseUrl = 'http://localhost:8080';
  
  static Future<Map<String, dynamic>> login(String identifier, String senha, bool isAluno) async {
    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        final client = http.Client();
        final response = await client.post(
          Uri.parse('$baseUrl/usuario/login'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(isAluno 
            ? {'rm': identifier, 'senha': senha}
            : {'email': identifier, 'senha': senha}),
        ).timeout(const Duration(seconds: 10));
        
        client.close();
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          await _saveUserSession(identifier);
          return {'success': true, 'data': data};
        } else {
          final error = jsonDecode(response.body);
          return {'success': false, 'message': error['message'] ?? 'Erro no login'};
        }
      } on SocketException {
        if (attempt == 2) return {'success': false, 'message': 'Servidor indisponível'};
        await Future.delayed(Duration(seconds: attempt + 1));
      } on HttpException {
        if (attempt == 2) return {'success': false, 'message': 'Erro de conexão HTTP'};
        await Future.delayed(Duration(seconds: attempt + 1));
      } catch (e) {
        if (attempt == 2) return {'success': false, 'message': 'Erro de conexão'};
        await Future.delayed(Duration(seconds: attempt + 1));
      }
    }
    return {'success': false, 'message': 'Falha na conexão'};
  }
  
  static Future<void> _saveUserSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    await prefs.setBool('is_logged_in', true);
  }
  
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }
  
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}