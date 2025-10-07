import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ocorrencia_model.dart';

class OcorrenciaController {
  static const String baseUrl = 'http://localhost:8080';

  Future<List<Ocorrencia>> buscarTodasOcorrencias() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ocorrencia/findAll'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Ocorrencia> ocorrencias = [];
        
        for (var item in data) {
          try {
            ocorrencias.add(Ocorrencia.fromJson(item as Map<String, dynamic>));
          } catch (e) {
            print('Erro ao processar item: $item - Erro: $e');
          }
        }
        
        ocorrencias.sort((a, b) => b.id.compareTo(a.id));
        return ocorrencias;
      } else {
        throw Exception('Erro ao buscar ocorrências: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro completo: $e');
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<List<Ocorrencia>> buscarOcorrenciasPendentes() async {
    final ocorrencias = await buscarTodasOcorrencias();
    return ocorrencias.where((o) => !o.resolvida).toList();
  }

  Future<List<Ocorrencia>> buscarOcorrenciasSolucionadas() async {
    final ocorrencias = await buscarTodasOcorrencias();
    return ocorrencias.where((o) => o.resolvida).toList();
  }

  Future<bool> salvarOcorrencia({
    required int usuarioId,
    required int localidadeId,
    required String descricao,
  }) async {
    try {
      final body = {
        "usuario": {"id": usuarioId},
        "localidade": {"id": localidadeId},
        "dataOcorrencia": DateTime.now().toIso8601String(),
        "descricao": descricao,
        "statusOcorrencia": "PENDENTE"
      };

      final response = await http.post(
        Uri.parse('$baseUrl/ocorrencia/save'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erro ao salvar ocorrência: $e');
      return false;
    }
  }
}