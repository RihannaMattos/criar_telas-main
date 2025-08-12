import 'package:flutter/material.dart';
import 'pagpendentes.dart';
import 'cadastro.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }



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
                      'LOGIN',
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
                      keyboardType: TextInputType.number,
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
                        onPressed: _login,
                        child: const Text(
                          'ENTRAR',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const CadastroScreen()),
                          );
                        },
                        child: const Text(
                          'Não tem cadastro? Clique aqui',
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
