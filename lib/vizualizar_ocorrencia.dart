import 'package:flutter/material.dart';
import 'models/ocorrencia_model.dart';

class VisualizarOcorrenciaPage extends StatelessWidget {
  final Ocorrencia ocorrencia;

  const VisualizarOcorrenciaPage({
    super.key,
    required this.ocorrencia,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1226),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1226),
        title: const Text('Detalhes da Ocorrência', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/opsdeitado.png',
                height: 80,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ocorrência #${ocorrencia.id}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow('Data de Envio:', 
                      '${ocorrencia.dataEnvio.day}/${ocorrencia.dataEnvio.month}/${ocorrencia.dataEnvio.year}'),
                    _buildInfoRow('Status:', 
                      ocorrencia.resolvida ? 'SOLUCIONADA' : 'PENDENTE',
                      valueColor: ocorrencia.resolvida ? Colors.green : Colors.red),
                    _buildInfoRow('Laboratório:', ocorrencia.laboratorio),
                    _buildInfoRow('Andar:', ocorrencia.andar),
                    _buildInfoRow('Patrimônio:', ocorrencia.patrimonio),
                    const SizedBox(height: 10),
                    const Text(
                      'Descrição do Problema:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(ocorrencia.problema),
                    ),
                    if (ocorrencia.fotoNome != null) ...[
                      const SizedBox(height: 15),
                      const Text(
                        'Foto Anexada:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(ocorrencia.fotoNome!),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C1226),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('VOLTAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}