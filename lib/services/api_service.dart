import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api'; // Altere para sua URL
  
  static Future<bool> login(String rm, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'rm': rm, 'senha': senha}),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> register(String rm, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'rm': rm, 'senha': senha}),
      );
      
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}