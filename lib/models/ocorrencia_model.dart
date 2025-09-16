class Ocorrencia {
  final int id;
  final String laboratorio;
  final String andar;
  final String problema;
  final String patrimonio;
  final String? fotoNome;
  final DateTime dataEnvio;
  bool resolvida;

  Ocorrencia({
    required this.id,
    required this.laboratorio,
    required this.andar,
    required this.problema,
    required this.patrimonio,
    this.fotoNome,
    required this.dataEnvio,
    this.resolvida = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'laboratorio': laboratorio,
      'andar': andar,
      'problema': problema,
      'patrimonio': patrimonio,
      'fotoNome': fotoNome,
      'dataEnvio': dataEnvio.toIso8601String(),
      'resolvida': resolvida ? 1 : 0,
    };
  }

  factory Ocorrencia.fromMap(Map<String, dynamic> map) {
    return Ocorrencia(
      id: map['id'] is int ? map['id'] : int.tryParse('${map['id']}') ?? 0,
      laboratorio: map['laboratorio'] ?? '',
      andar: map['andar'] ?? '',
      problema: map['problema'] ?? '',
      patrimonio: map['patrimonio'] ?? '',
      fotoNome: map['fotoNome'],
      dataEnvio: DateTime.parse(map['dataEnvio']),
      resolvida: map['resolvida'] == 1 || map['resolvida'] == true,
    );
  }
}