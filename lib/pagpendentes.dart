import 'package:flutter/material.dart';
import 'occorrencia.dart';
import 'principal.dart';
import 'services/ocorrencia_service.dart';
import 'services/auth_service.dart';
import 'models/ocorrencia_model.dart';
import 'vizuocorrenciapendente.dart';
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final OcorrenciaService _ocorrenciaService = OcorrenciaService();
  
  @override
  Widget build(BuildContext context) {
    final isPending = selectedIndex == 0;
    final ocorrencias = isPending 
        ? _ocorrenciaService.getOcorrenciasPendentes() 
        : _ocorrenciaService.getOcorrenciasSolucionadas();
 
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/opsdeitado.png',
                height: 80,
              ),
              const SizedBox(height: 24),
              _buildTitleBox('OCORRÊNCIAS'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => selectedIndex = 0),
                    child: _buildButton('PENDENTES', ativo: isPending),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => selectedIndex = 1),
                    child: _buildButton('SOLUCIONADAS', ativo: !isPending),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isPending ? 'HISTÓRICO DE PENDENTES:' : 'HISTÓRICO DE SOLUCIONADAS:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ocorrencias.isEmpty
                  ? Center(
                      child: Text(
                        isPending 
                            ? 'Não há ocorrências pendentes' 
                            : 'Não há ocorrências solucionadas',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: ocorrencias.length,
                      itemBuilder: (context, index) {
                        final ocorrencia = ocorrencias[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VisualizarOcorrenciaPage(
                                  ocorrencia: ocorrencia,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: _buildCard(
                              ocorrencia: ocorrencia,
                              isPending: isPending,
                            ),
                          ),
                        );
                      },
                    ),
              ),
              const SizedBox(height: 16),
              _buildCriarOcorrenciaButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
  
  Widget _buildButton(String text, {required bool ativo}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1226),
        borderRadius: BorderRadius.circular(12),
        boxShadow: ativo
            ? [const BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(2, 2))]
            : [],
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
 
  Widget _buildTitleBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.grey[300],
      child: Text(text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
 
  Widget _buildCard({required Ocorrencia ocorrencia, required bool isPending}) {
    final status = isPending ? 'PENDENTE' : 'SOLUCIONADA';
    final color = isPending ? const Color(0xFFD32F2F) : Colors.green;
    final bgColor = isPending ? const Color(0xFFFFE5E5) : Colors.green[100]!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Data De Envio: ${ocorrencia.dataEnvio.day}/${ocorrencia.dataEnvio.month}/${ocorrencia.dataEnvio.year}'),
          Text('Nº Da Ocorrência: ${ocorrencia.id}'),
          Text('Lab: ${ocorrencia.laboratorio} - ${ocorrencia.andar}'),
          const SizedBox(height: 8),
          Text('Status: $status',
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
 
  Widget _buildCriarOcorrenciaButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CriarOcorrenciaPage()),
        );
      },
      icon: const Icon(Icons.add, color: Colors.black),
      label: const Text('CRIAR OCORRÊNCIA', style: TextStyle(color: Colors.black)),
    );
  }
 
  Widget _buildBottomBar() {
    return Container(
      color: const Color(0xFF0C1226),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.account_circle, color: Colors.white),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('rm90899@dominio.fieb.edu.br', style: TextStyle(color: Colors.white)),
          ),
          GestureDetector(
            onTap: () async {
              await AuthService.logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PrincipalScreen()),
                );
              }
            },
            child: const Text('Sair da Conta',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                )),
          ),
        ],
      ),
    );
  }
}