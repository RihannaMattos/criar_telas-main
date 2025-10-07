class Ocorrencia {
  final int id;
  final String laboratorio;
  final String andar;
  final String problema;
  final String patrimonio;
  final String? fotoNome;
  final DateTime dataEnvio;
  bool resolvida;
  final String? localidadeNome;

  Ocorrencia({
    required this.id,
    required this.laboratorio,
    required this.andar,
    required this.problema,
    required this.patrimonio,
    this.fotoNome,
    required this.dataEnvio,
    this.resolvida = false,
    this.localidadeNome,
  });

  factory Ocorrencia.fromJson(Map<String, dynamic> json) {
    return Ocorrencia(
      id: json['id'] ?? 0,
      laboratorio: json['laboratorio']?.toString() ?? '',
      andar: json['andar']?.toString() ?? '',
      problema: json['descricao']?.toString() ?? json['problema']?.toString() ?? '',
      patrimonio: json['patrimonio']?.toString() ?? '',
      fotoNome: json['fotoNome']?.toString(),
      dataEnvio: json['dataOcorrencia'] != null ? DateTime.tryParse(json['dataOcorrencia'].toString()) ?? DateTime.now() : 
                 json['dataEnvio'] != null ? DateTime.tryParse(json['dataEnvio'].toString()) ?? DateTime.now() : DateTime.now(),
      resolvida: json['statusOcorrencia'] == 'SOLUCIONADA' || json['resolvida'] == true || json['resolvida'] == 'true',
      localidadeNome: json['localidade']?['nome']?.toString(),
    );
  }
}