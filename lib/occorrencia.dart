import 'package:flutter/material.dart';
import 'controllers/ocorrencia_controller.dart';
import 'services/auth_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const OcorrenciaApp());  //essa pág é de CRIAR ocorrência//

class OcorrenciaApp extends StatelessWidget {
  const OcorrenciaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CriarOcorrenciaPage(),
    );
  }
}

class CriarOcorrenciaPage extends StatefulWidget {
  const CriarOcorrenciaPage({super.key});
 
  @override
  State<CriarOcorrenciaPage> createState() => _CriarOcorrenciaPageState();
}
 
class _CriarOcorrenciaPageState extends State<CriarOcorrenciaPage> {
  final TextEditingController problemaController = TextEditingController();
  final OcorrenciaController _ocorrenciaController = OcorrenciaController();
  String? selectedLocalidade;
  List<Map<String, dynamic>> localidades = [];
  bool isLoadingLocalidades = true;
  bool isEnviando = false;

  @override
  void initState() {
    super.initState();
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

  Future<bool> _enviarOcorrencia({
    required String usuarioRm,
    required int localidadeId,
    required String descricao,
  }) async {
    try {
      final body = {
        "usuario": {
          "id": 1,
          "nome": "Usuário",
          "rm": usuarioRm,
          "email": "usuario@example.com",
          "senha": "MTIzNDU2Nzg=",
          "nivelAcesso": "USER",
          "dataCadastro": DateTime.now().toIso8601String(),
          "statusUsuario": "ATIVO"
        },
        "localidade": {
          "id": localidadeId,
          "nome": "Localidade",
          "statusLocal": "ATIVO"
        },
        "dataOcorrencia": DateTime.now().toIso8601String(),
        "descricao": descricao,
        "statusOcorrencia": "PENDENTE"
      };

      final response = await http.post(
        Uri.parse('http://localhost:8080/ocorrencia/save'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1226),
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
              const Text(
                'CRIE A OCORRÊNCIA',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                    const Text('INSIRA AS INFORMAÇÕES',
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
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonFormField<String>(
                              initialValue: selectedLocalidade,
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
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedLocalidade = newValue;
                                });
                              },
                            ),
                          ),
                    const SizedBox(height: 20),
                    const Text('DESCREVA O PROBLEMA:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: problemaController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'escreva:',
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildActionButton('ENVIAR', onPressed: isEnviando ? null : () async {
                if (selectedLocalidade == null || problemaController.text.isEmpty) {
                  _mostrarErro('Por favor, preencha todos os campos obrigatórios');
                  return;
                }
                
                setState(() => isEnviando = true);
                
                try {
                  final userRm = await AuthService.getCurrentUserRm();
                  final success = await _enviarOcorrencia(
                    usuarioRm: userRm ?? '00000',
                    localidadeId: int.parse(selectedLocalidade!),
                    descricao: problemaController.text,
                  );
                  
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ocorrência criada com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context, true);
                  } else {
                    _mostrarErro('Erro ao criar ocorrência');
                  }
                } catch (e) {
                  _mostrarErro('Erro: $e');
                } finally {
                  setState(() => isEnviando = false);
                }
              }, filled: true),
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
 
  Widget _buildDropdownButton({
    required String hint,
    required String? value,
    required void Function(String?) onChanged,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1226),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 4)],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.black),
          isExpanded: true,
          onChanged: onChanged,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
        ),
      ),
    );
  }
 
  Widget _buildActionButton(String label,
      {required VoidCallback? onPressed, required bool filled}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: filled ? const Color(0xFF0C1226) : Colors.grey[300],
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
      child: isEnviando && label == 'ENVIAR'
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
    );
  }
}
