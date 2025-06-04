import 'package:flutter/material.dart';

class VisualizarOcorrenciaPendentePage extends StatefulWidget {
  const VisualizarOcorrenciaPendentePage({super.key, required String status});

  @override
  State<VisualizarOcorrenciaPendentePage> createState() => _VisualizarOcorrenciaPendentePageState();
}

class _VisualizarOcorrenciaPendentePageState extends State<VisualizarOcorrenciaPendentePage> {
  final bool isPendente = true;
  late Color statusColor;
  late String statusTexto;

  @override
  void initState() {
    super.initState();
    statusColor = Colors.red[800]!;
    statusTexto = 'PENDENTE';
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
                      const Text(
                        'DATA DE ENVIO  00/00/00\nNº DA OCORRÊNCIA: XXX',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'ANDAR DO LABORATÓRIO:',
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
                        child: const Text(
                          'ANDAR SELECIONADO',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'NÚMERO DO LABORATÓRIO:',
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
                        child: const Text(
                          'LAB. SELECIONADO',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                        child: const Text(
                          'Texto da Descrição do problema pelo usuário...',
                          style: TextStyle(color: Colors.black54),
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
