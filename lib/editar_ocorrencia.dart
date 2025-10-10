import 'package:flutter/material.dart';
import 'models/ocorrencia_model.dart';
import 'services/ocorrencia_cache_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditarOcorrenciaPage extends StatefulWidget {
  final Ocorrencia ocorrencia;

  const EditarOcorrenciaPage({
    super.key,
    required this.ocorrencia,
  });

  @override
  State<EditarOcorrenciaPage> createState() => _EditarOcorrenciaPageState();
}

class _EditarOcorrenciaPageState extends State<EditarOcorrenciaPage> {
  final TextEditingController problemaController = TextEditingController();
  String? selectedLocalidade;
  List<Map<String, dynamic>> localidades = [];
  bool isLoadingLocalidades = true;
  bool isEnviando = false;

  @override
  void initState() {
    super.initState();
    problemaController.text = widget.ocorrencia.problema;
    _carregarLocalidades();
  }

  Future<void> _carregarLocalidades() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/localidade/findAll'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          localidades = data.cast<Map<String, dynamic>>();
          // Tentar encontrar a localidade atual da ocorrência
          if (widget.ocorrencia.localidadeNome != null) {
            final localidadeAtual = localidades.firstWhere(
              (loc) => loc['nome'] == widget.ocorrencia.localidadeNome,
              orElse: () => {},
            );
            if (localidadeAtual.isNotEmpty) {
              selectedLocalidade = localidadeAtual['id'].toString();
            }
          }
          isLoadingLocalidades = false;
        });
      } else {
        setState(() {
          isLoadingLocalidades = false;
        });
        _mostrarErro('Erro ao carregar localidades');
      }
    } catch (e) {
      setState(() {
        isLoadingLocalidades = false;
      });
      _mostrarErro('Erro de conexão: $e');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Função para simular a edição (apenas frontend)
  Future<bool> _editarOcorrencia() async {
    try {
      // Simula uma requisição de edição
      await Future.delayed(const Duration(seconds: 1));
      
      // Obtém o nome da localidade selecionada
      final localidadeSelecionada = localidades.firstWhere(
        (loc) => loc['id'].toString() == selectedLocalidade,
        orElse: () => {'nome': 'Localidade não encontrada'},
      );
      
      // Salva as alterações no cache local
      await OcorrenciaCacheService.salvarOcorrenciaEditada(
        id: widget.ocorrencia.id,
        novaDescricao: problemaController.text,
        novaLocalidade: localidadeSelecionada['nome'],
      );
      
      return true;
    } catch (e) {
      return false;
    }
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
      return "Tempo esgotado";
    }
    
    return "Tempo restante: ${minutosRestantes}min";
  }

  @override
  Widget build(BuildContext context) {
    final podeEditar = _podeEditar();
    
    return Scaffold(
      backgroundColor: const Color(0xFF0C1226),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1226),
        title: const Text('Editar Ocorrência', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/opsdeitado.png',
                height: 80,
              ),
              const SizedBox(height: 20),
              Text(
                'EDITAR OCORRÊNCIA #${widget.ocorrencia.id}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: podeEditar ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _tempoRestante(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('EDITAR INFORMAÇÕES',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    const SizedBox(height: 20),
                    const Text('LOCALIDADE:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    isLoadingLocalidades
                        ? Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: podeEditar ? Colors.grey[300] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: selectedLocalidade,
                              hint: const Text('Selecione uma localidade'),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                              ),
                              items: localidades.map((localidade) {
                                return DropdownMenuItem<String>(
                                  value: localidade['id'].toString(),
                                  child: Text(localidade['nome'] ?? 'Sem nome'),
                                );
                              }).toList(),
                              onChanged: podeEditar ? (String? newValue) {
                                setState(() {
                                  selectedLocalidade = newValue;
                                });
                              } : null,
                            ),
                          ),
                    const SizedBox(height: 20),
                    const Text('DESCREVA O PROBLEMA:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: problemaController,
                      maxLines: 4,
                      enabled: podeEditar,
                      decoration: InputDecoration(
                        hintText: 'escreva:',
                        filled: true,
                        fillColor: podeEditar ? Colors.grey[300] : Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (!podeEditar) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.red[700], size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.ocorrencia.resolvida 
                                  ? 'Esta ocorrência já foi solucionada e não pode ser editada.'
                                  : 'O tempo limite de 15 minutos para edição expirou.',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildActionButton('SALVAR ALTERAÇÕES', 
                onPressed: (podeEditar && !isEnviando) ? () async {
                  if (selectedLocalidade == null || problemaController.text.isEmpty) {
                    _mostrarErro('Por favor, preencha todos os campos obrigatórios');
                    return;
                  }
                  
                  setState(() => isEnviando = true);
                  
                  try {
                    final success = await _editarOcorrencia();
                    
                    if (success) {
                      _mostrarSucesso('Ocorrência editada com sucesso!');
                      // Aguarda um pouco para mostrar a mensagem antes de voltar
                      await Future.delayed(const Duration(seconds: 1));
                      Navigator.pop(context, true);
                    } else {
                      _mostrarErro('Erro ao editar ocorrência');
                    }
                  } catch (e) {
                    _mostrarErro('Erro: $e');
                  } finally {
                    setState(() => isEnviando = false);
                  }
                } : null, 
                filled: true),
              const SizedBox(height: 12),
              _buildActionButton('CANCELAR', onPressed: () {
                Navigator.pop(context);
              }, filled: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label,
      {required VoidCallback? onPressed, required bool filled}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: filled ? const Color(0xFF0C1226) : Colors.grey[300],
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: isEnviando && label == 'SALVAR ALTERAÇÕES'
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: filled ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}