import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ocorrencia_model.dart';
import 'database_service.dart';

// Serviço singleton para gerenciar ocorrências em memória
class OcorrenciaService {
  static final OcorrenciaService _instance = OcorrenciaService._internal();
  
  factory OcorrenciaService() {
    return _instance;
  }
  
  OcorrenciaService._internal() {
    _init();
  }
  
  // Lista de ocorrências em memória
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
  
  // Obter todas as ocorrências
  Future<List<Ocorrencia>> getOcorrencias() async {
    await _init();
    return List.from(_ocorrencias);
  }
  
  // Obter ocorrências pendentes
  Future<List<Ocorrencia>> getOcorrenciasPendentes() async {
    await _init();
    return _ocorrencias.where((o) => !o.resolvida).toList();
  }
  
  // Obter ocorrências solucionadas
  Future<List<Ocorrencia>> getOcorrenciasSolucionadas() async {
    await _init();
    return _ocorrencias.where((o) => o.resolvida).toList();
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