import 'package:flutter/material.dart';
import 'occorrencia.dart';
  
class OpsApp extends StatelessWidget {
  const OpsApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OPS!',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Arial',
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
 
  @override
  Widget build(BuildContext context) {
    final isPending = selectedIndex == 0;
 
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.build_circle, size: 80, color: Colors.black87),
            const Text(
              'OPS!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'OCORRÊNCIAS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.black12,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton("PENDENTES", 0),
                const SizedBox(width: 10),
                _buildTabButton("SOLUCIONADAS", 1),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'HISTÓRICO DE PENDENTES:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildOcorrenciaCard(isPending),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CriarOcorrenciaPage()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("CRIAR OCORRÊNCIA"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const Spacer(),
            Container(
              color: Colors.indigo[900],
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'rm90899@dominio.fieb.edu.br\nSair da Conta',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
 
  Widget _buildTabButton(String text, int index) {
    final isSelected = selectedIndex == index;
    return ElevatedButton(
      onPressed: () => setState(() => selectedIndex = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.indigo[900] : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(text),
    );
  }
 
  Widget _buildOcorrenciaCard(bool isPending) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.red[100],
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data De Envio: 00/00/00", style: TextStyle(fontWeight: FontWeight.bold)),
            const Text("Nº Da Ocorrência", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              "Status: ${isPending ? 'PENDENTE' : 'SOLUCIONADA'}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPending ? Colors.red[900] : Colors.green[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}