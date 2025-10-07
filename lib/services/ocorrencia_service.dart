import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ocorrencia_model.dart';

class OcorrenciaService {
  static const String baseUrl = 'http://localhost:8080';
  
  // Lista de ocorrências em memória (fallback)
  final List<Ocorrencia> _ocorrencias = [];
  int _nextId = 1;
  
  // Adicionar uma nova ocorrência
  Ocorrencia adicionarOcorrencia({
    required String laboratorio,
    required String andar,
    required String problema,
    required String patrimonio,
  }) {
    final ocorrencia = Ocorrencia(
      id: _nextId++,
      laboratorio: laboratorio,
      andar: andar,
      problema: problema,
      patrimonio: patrimonio,
      dataEnvio: DateTime.now(),
    );
    
    _ocorrencias.add(ocorrencia);
    return ocorrencia;
  }
  
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
    return List.from(_ocorrencias);
  }
  
  // Obter ocorrências pendentes
  Future<List<Ocorrencia>> getOcorrenciasPendentes() async {
    final ocorrencias = await getOcorrencias();
    return ocorrencias.where((o) => !o.resolvida).toList();
  }
  
  // Obter ocorrências solucionadas
  Future<List<Ocorrencia>> getOcorrenciasSolucionadas() async {
    final ocorrencias = await getOcorrencias();
    return ocorrencias.where((o) => o.resolvida).toList();
  }
  
  // Obter uma ocorrência pelo ID
  Ocorrencia? getOcorrenciaPorId(int id) {
    try {
      return _ocorrencias.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Marcar uma ocorrência como resolvida
  void marcarComoResolvida(int id) {
    final ocorrencia = getOcorrenciaPorId(id);
    if (ocorrencia != null) {
      ocorrencia.resolvida = true;
    }
  }
}