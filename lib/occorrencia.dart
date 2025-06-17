import 'package:flutter/material.dart';

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

class CriarOcorrenciaPage extends StatelessWidget {
  const CriarOcorrenciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Container(
                    color: const Color(0xFF07122C),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Image.asset(
                          'assets/images/imagem.png', // Adicione um ícone conforme a imagem original
                          height: 50,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'OPS!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'CRIE A OCORRÊNCIA',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'INSIRA AS INFORMAÇÕES',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        const Text('QUAL O LABORATÓRIO?', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          decoration: dropDecoration,
                          items: const [
                            DropdownMenuItem(value: 'lab1', child: Text('Lab 1')),
                            DropdownMenuItem(value: 'lab2', child: Text('Lab 2')),
                          ],
                          onChanged: (value) {},
                          hint: const Text('SELECIONE O LAB'),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: dropDecoration,
                          items: const [
                            DropdownMenuItem(value: '1', child: Text('1º Andar')),
                            DropdownMenuItem(value: '2', child: Text('2º Andar')),
                          ],
                          onChanged: (value) {},
                          hint: const Text('SELECIONE O ANDAR'),
                        ),
                        const SizedBox(height: 16),
                        const Text('DESCREVA O PROBLEMA:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextFormField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'escreva:',
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('PATRIMÔNIO:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'ex: 041776',
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('ENVIE UMA FOTO:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.attach_file),
                              SizedBox(width: 8),
                              Text('ANEXAR'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF07122C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text('ENVIAR'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text('CANCELAR'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const InputDecoration dropDecoration = InputDecoration(
  filled: true,
  fillColor: Color(0xFF07122C),
  hintStyle: TextStyle(color: Colors.white),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
);
