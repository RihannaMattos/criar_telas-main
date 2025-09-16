import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'services/ocorrencia_service.dart';
import '../models/ocorrencia_model.dart';
import 'database_service.dart';

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
  final TextEditingController localidadeController = TextEditingController();
  final TextEditingController problemaController = TextEditingController();
 
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
                    TextField(
                      controller: localidadeController,
                      decoration: InputDecoration(
                        hintText: 'ex: Laboratório 1, Sala 205, etc.',
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
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
              _buildActionButton('ENVIAR', onPressed: () async {
                if (localidadeController.text.isEmpty || 
                    problemaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, preencha todos os campos obrigatórios'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final ocorrenciaService = OcorrenciaService();
                final novaOcorrencia = await ocorrenciaService.adicionarOcorrencia(
                  laboratorio: localidadeController.text,
                  andar: '',
                  problema: problemaController.text,
                  patrimonio: '',
                );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ocorrência criada com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
                
                if (mounted) {
                  Navigator.pop(context, novaOcorrencia);
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
      {required VoidCallback onPressed, required bool filled}) {
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
      child: Text(
        label,
        style: TextStyle(
          color: filled ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
