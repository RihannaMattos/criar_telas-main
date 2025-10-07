import 'dart:convert';
<<<<<<< HEAD
import 'package:http/http.dart' as http;
=======
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> 60d53951c411376c76b642f8a2a859ec2e8f4491
import '../models/ocorrencia_model.dart';
import 'database_service.dart';

class OcorrenciaService {
  static const String baseUrl = 'http://localhost:8080';
  
<<<<<<< HEAD
  // Lista de ocorrências em memória (fallback)
=======
  factory OcorrenciaService() {
    return _instance;
  }
  
  OcorrenciaService._internal() {
    _init();
  }
  
  // Lista de ocorrências em memória
>>>>>>> 60d53951c411376c76b642f8a2a859ec2e8f4491
  final List<Ocorrencia> _ocorrencias = [];
  int _nextId = 1;
  bool _loaded = false;

  Future<void> _init() async {
    if (_loaded) return;
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('ocorrencias');
      if (raw != null) {
        final list = (jsonDecode(raw) as List)
            .map((e) => Ocorrencia.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        _ocorrencias
          ..clear()
          ..addAll(list);
      }
    } else {
      final rows = await DatabaseService.getOcorrencias();
      _ocorrencias
        ..clear()
        ..addAll(rows.map((m) => Ocorrencia.fromMap(m)));
    }
    _nextId = _ocorrencias.isEmpty
        ? 1
        : (_ocorrencias.map((o) => o.id).reduce((a, b) => a > b ? a : b) + 1);
    _loaded = true;
  }

  Future<void> _persistAll() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(_ocorrencias.map((o) => o.toMap()).toList());
      await prefs.setString('ocorrencias', raw);
    }
  }
  
  // Adicionar uma nova ocorrência
  Future<Ocorrencia> adicionarOcorrencia({
    required String laboratorio,
    required String andar,
    required String problema,
    required String patrimonio,
  }) async {
    await _init();
    final ocorrencia = Ocorrencia(
      id: _nextId++,
      laboratorio: laboratorio,
      andar: andar,
      problema: problema,
      patrimonio: patrimonio,
      dataEnvio: DateTime.now(),
    );
    
    _ocorrencias.add(ocorrencia);
    if (kIsWeb) {
      await _persistAll();
    } else {
      await DatabaseService.insertOcorrencia(ocorrencia.toMap());
    }
    return ocorrencia;
  }
  
<<<<<<< HEAD
  // Obter todas as ocorrências da API
  Future<List<Ocorrencia>> getOcorrencias() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ocorrencia/findAll'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Ocorrencia.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      print('Erro ao buscar ocorrências: $e');
    }
=======
  // Obter todas as ocorrências
  Future<List<Ocorrencia>> getOcorrencias() async {
    await _init();
>>>>>>> 60d53951c411376c76b642f8a2a859ec2e8f4491
    return List.from(_ocorrencias);
  }
  
  // Obter ocorrências pendentes
  Future<List<Ocorrencia>> getOcorrenciasPendentes() async {
<<<<<<< HEAD
    final ocorrencias = await getOcorrencias();
    return ocorrencias.where((o) => !o.resolvida).toList();
=======
    await _init();
    return _ocorrencias.where((o) => !o.resolvida).toList();
>>>>>>> 60d53951c411376c76b642f8a2a859ec2e8f4491
  }
  
  // Obter ocorrências solucionadas
  Future<List<Ocorrencia>> getOcorrenciasSolucionadas() async {
<<<<<<< HEAD
    final ocorrencias = await getOcorrencias();
    return ocorrencias.where((o) => o.resolvida).toList();
=======
    await _init();
    return _ocorrencias.where((o) => o.resolvida).toList();
>>>>>>> 60d53951c411376c76b642f8a2a859ec2e8f4491
  }
  
  // Obter uma ocorrência pelo ID
  Future<Ocorrencia?> getOcorrenciaPorId(int id) async {
    await _init();
    try {
      return _ocorrencias.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Marcar uma ocorrência como resolvida
  Future<void> marcarComoResolvida(int id) async {
    await _init();
    final ocorrencia = _ocorrencias.firstWhere(
      (o) => o.id == id,
      orElse: () => throw StateError('Ocorrência não encontrada'),
    );
    ocorrencia.resolvida = true;
    if (kIsWeb) {
      await _persistAll();
    } else {
      await DatabaseService.marcarOcorrenciaResolvida(id);
    }
  }
}