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

  factory Ocorrencia.fromJson(Map<String, dynamic> json) {
    return Ocorrencia(
      id: json['id'] ?? 0,
      laboratorio: json['laboratorio']?.toString() ?? '',
      andar: json['andar']?.toString() ?? '',
      problema: json['problema']?.toString() ?? '',
      patrimonio: json['patrimonio']?.toString() ?? '',
      fotoNome: json['fotoNome']?.toString(),
      dataEnvio: json['dataEnvio'] != null ? DateTime.tryParse(json['dataEnvio'].toString()) ?? DateTime.now() : DateTime.now(),
      resolvida: json['resolvida'] == true || json['resolvida'] == 'true',
    );
  }
}