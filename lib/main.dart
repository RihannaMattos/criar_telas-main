import 'package:criar_telas/pagpendentes.dart';
import 'package:flutter/material.dart';
import 'tela2.dart'; // importa a nova tela
import 'cadastro.dart';
import 'login.dart';
import 'principal.dart';
import 'occorrencia.dart';
import 'vizuocorrencia.dart';
import 'vizuocorrenciapendente.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App com Navegação',
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrincipalScreen()),
            );
          },
          child: Image.asset("assets/images/imagem.png"),
        ),
      ),
    );
  }
}
