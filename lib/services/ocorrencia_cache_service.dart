import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OcorrenciaCacheService {
  static const String _editedOccurrencesKey = 'edited_occurrences';
  static const String _deletedOccurrencesKey = 'deleted_occurrences';

  // Salva uma ocorrência editada no cache local
  static Future<void> salvarOcorrenciaEditada({
    required int id,
    required String novaDescricao,
    required String novaLocalidade,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Recupera ocorrências editadas existentes
    final editedJson = prefs.getString(_editedOccurrencesKey) ?? '{}';
    final Map<String, dynamic> editedOccurrences = jsonDecode(editedJson);
    
    // Adiciona/atualiza a ocorrência editada
    editedOccurrences[id.toString()] = {
      'descricao': novaDescricao,
      'localidade': novaLocalidade,
      'dataEdicao': DateTime.now().toIso8601String(),
    };
    
    // Salva de volta
    await prefs.setString(_editedOccurrencesKey, jsonEncode(editedOccurrences));
  }

  // Recupera dados editados de uma ocorrência
  static Future<Map<String, dynamic>?> obterDadosEditados(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final editedJson = prefs.getString(_editedOccurrencesKey) ?? '{}';
    final Map<String, dynamic> editedOccurrences = jsonDecode(editedJson);
    
    return editedOccurrences[id.toString()];
  }

  // Marca uma ocorrência como apagada
  static Future<void> marcarComoApagada(int id) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Recupera ocorrências apagadas existentes
    final deletedJson = prefs.getString(_deletedOccurrencesKey) ?? '[]';
    final List<dynamic> deletedOccurrences = jsonDecode(deletedJson);
    
    // Adiciona o ID se não estiver na lista
    if (!deletedOccurrences.contains(id)) {
      deletedOccurrences.add(id);
      await prefs.setString(_deletedOccurrencesKey, jsonEncode(deletedOccurrences));
    }
  }

  // Verifica se uma ocorrência foi apagada
  static Future<bool> foiApagada(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final deletedJson = prefs.getString(_deletedOccurrencesKey) ?? '[]';
    final List<dynamic> deletedOccurrences = jsonDecode(deletedJson);
    
    return deletedOccurrences.contains(id);
  }

  // Limpa o cache (útil para testes)
  static Future<void> limparCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_editedOccurrencesKey);
    await prefs.remove(_deletedOccurrencesKey);
  }
}