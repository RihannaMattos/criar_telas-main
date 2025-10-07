import 'package:flutter/material.dart';
import 'models/ocorrencia_model.dart';

class VisualizarOcorrenciaPage extends StatefulWidget {
  final Ocorrencia ocorrencia;

  const VisualizarOcorrenciaPage({super.key, required this.ocorrencia});

  @override
  State<VisualizarOcorrenciaPage> createState() => _VisualizarOcorrenciaPageState();
}

class _VisualizarOcorrenciaPageState extends State<VisualizarOcorrenciaPage> {
  late bool isPendente;
  late Color statusColor;
  late String statusTexto;

  @override
  void initState() {
    super.initState();
    _atualizarStatus();
  }

  void _atualizarStatus() {
    isPendente = !widget.ocorrencia.resolvida;
    statusColor = isPendente ? Colors.red[800]! : Colors.green[700]!;
    statusTexto = isPendente ? 'PENDENTE' : 'SOLUCIONADA';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 380,
                decoration: BoxDecoration(
                  color: const Color(0xFF07122C),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'DATA DE ENVIO  ${widget.ocorrencia.dataEnvio.day.toString().padLeft(2, '0')}/${widget.ocorrencia.dataEnvio.month.toString().padLeft(2, '0')}/${widget.ocorrencia.dataEnvio.year}\nNº DA OCORRÊNCIA: ${widget.ocorrencia.id}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'LOCALIDADE:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(2, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          widget.ocorrencia.laboratorio.isNotEmpty ? widget.ocorrencia.laboratorio : 'Não informado',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'DESCRIÇÃO DO PROBLEMA:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          widget.ocorrencia.problema.isNotEmpty ? widget.ocorrencia.problema : 'Descrição não informada',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'CLIQUE AO LADO PARA VISUALIZAR A IMAGEM',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text('VISUALIZAR FOTO'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'STATUS:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusTexto,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
