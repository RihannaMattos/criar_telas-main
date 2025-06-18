import 'package:flutter/material.dart';
import 'principal.dart';
import 'pagpendentes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CadastroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060C2C), // Fundo azul escuro
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo
              Image.asset(
                'assets/images/imagem.png',
                height: 400,
              ),
              const SizedBox(height: 40),
              // Container branco com bordas arredondadas
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CADASTRO',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B0F2F),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'COLOQUE SEU RM',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Seu RM:',
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'SENHA',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Sua Senha',
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 4,
                        ),
                        onPressed: () {
                          // Navega para a página principal ao clicar em CADASTRAR
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const PrincipalScreen()),
                          );
                        },
                        child: const Text(
                          'CADASTRAR',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PrincipalScreen()),
                          );
                        },
                        child: const Text(
                          'Já tem Cadastro? Clique aqui',
                          style: TextStyle(
                            color: Color(0xFF0B0F2F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
