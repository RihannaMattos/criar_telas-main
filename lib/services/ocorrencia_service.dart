import '../models/ocorrencia_model.dart';

// Serviço singleton para gerenciar ocorrências em memória
class OcorrenciaService {
  static final OcorrenciaService _instance = OcorrenciaService._internal();
  
  factory OcorrenciaService() {
    return _instance;
  }
  
  OcorrenciaService._internal();
  
  // Lista de ocorrências em memória
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
  
  // Obter todas as ocorrências
  List<Ocorrencia> getOcorrencias() {
    return List.from(_ocorrencias);
  }
  
  // Obter ocorrências pendentes
  List<Ocorrencia> getOcorrenciasPendentes() {
    return _ocorrencias.where((o) => !o.resolvida).toList();
  }
  
  // Obter ocorrências solucionadas
  List<Ocorrencia> getOcorrenciasSolucionadas() {
    return _ocorrencias.where((o) => o.resolvida).toList();
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