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
}