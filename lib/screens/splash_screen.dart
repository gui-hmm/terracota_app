import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Pacote para verificar o login
import '../utils/auth_service.dart';  // Função para verificar o login

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Verifica se o usuário está logado após 3 segundos
    Future.delayed(const Duration(seconds: 3), () async {
      bool isLoggedIn = await checkLoginStatus();  // Chama a função para verificar o login
      if (isLoggedIn) {
        // Se estiver logado, vai para a tela inicial
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Se não estiver logado, vai para a tela de login
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/images/Bemvindo.png', // Caminho da imagem de fundo
              fit: BoxFit.cover,
            ),
          ),
          // Imagem centralizada
          Center(
            child: Image.asset(
              'assets/images/logomarca.png', // Caminho da logomarca
              width: 300, 
              height: 300,
            ),
          ),
        ],
      ),
    );
  }
}
