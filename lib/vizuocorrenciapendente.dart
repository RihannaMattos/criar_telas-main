import 'package:flutter/material.dart';
import 'models/ocorrencia_model.dart';
import 'services/ocorrencia_cache_service.dart';
import 'editar_ocorrencia.dart';

class VisualizarOcorrenciaPage extends StatefulWidget {
  final Ocorrencia ocorrencia;

  const VisualizarOcorrenciaPage({
    super.key,
    required this.ocorrencia,
  });

  @override
  State<VisualizarOcorrenciaPage> createState() => _VisualizarOcorrenciaPageState();
}

class _VisualizarOcorrenciaPageState extends State<VisualizarOcorrenciaPage> {
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
                      'Ocorrência #${widget.ocorrencia.id}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow('Data de Envio:', 
                      '${widget.ocorrencia.dataEnvio.day}/${widget.ocorrencia.dataEnvio.month}/${widget.ocorrencia.dataEnvio.year}'),
                    _buildInfoRow('Status:', 
                      widget.ocorrencia.resolvida ? 'SOLUCIONADA' : 'PENDENTE',
                      valueColor: widget.ocorrencia.resolvida ? Colors.green : Colors.red),
                    _buildInfoRow('Localidade:', 
                      widget.ocorrencia.localidadeNome?.isNotEmpty == true ? widget.ocorrencia.localidadeNome! : 'Não informado'),
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
                      child: Text(widget.ocorrencia.problema),
                    ),
                    if (widget.ocorrencia.fotoNome != null) ...[
                      const SizedBox(height: 15),
                      const Text(
                        'Foto Anexada:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(widget.ocorrencia.fotoNome!),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Avisos e botões de ação
              if (_podeEditar()) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.green[700], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Você pode editar ou apagar esta ocorrência por ${_tempoRestante()}.',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          final resultado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarOcorrenciaPage(
                                ocorrencia: widget.ocorrencia,
                              ),
                            ),
                          );
                          
                          if (resultado == true) {
                            Navigator.pop(context, true);
                          }
                        },
                        child: const Text('EDITAR'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => _mostrarDialogoApagar(),
                        child: const Text('APAGAR'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ] else if (!widget.ocorrencia.resolvida) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange[700], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'O tempo limite de 15 minutos para editar ou apagar esta ocorrência expirou.',
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
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

  bool _podeEditar() {
    final agora = DateTime.now();
    final diferenca = agora.difference(widget.ocorrencia.dataEnvio);
    return diferenca.inMinutes <= 15 && !widget.ocorrencia.resolvida;
  }

  String _tempoRestante() {
    final agora = DateTime.now();
    final diferenca = agora.difference(widget.ocorrencia.dataEnvio);
    final minutosRestantes = 15 - diferenca.inMinutes;
    
    if (minutosRestantes <= 0) {
      return "tempo esgotado";
    }
    
    return "${minutosRestantes}min";
  }

  void _mostrarDialogoApagar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text(
            'Tem certeza que deseja apagar a ocorrência #${widget.ocorrencia.id}?\n\nEsta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCELAR'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _apagarOcorrencia();
              },
              child: const Text('APAGAR'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _apagarOcorrencia() async {
    try {
      // Marca a ocorrência como apagada no cache local
      await OcorrenciaCacheService.marcarComoApagada(widget.ocorrencia.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocorrência apagada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Volta para a tela anterior indicando que houve mudança
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao apagar ocorrência'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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