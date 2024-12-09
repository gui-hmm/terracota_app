import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart'; // Certifique-se de importar o provider
import 'package:terracota/utils/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  // Função de validação
  bool _validarCampos() {
    if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
      _showSnackBar('Todos os campos precisam ser preenchidos!');
      return false;
    }

    // Validar e-mail
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(_emailController.text)) {
      _showSnackBar('Por favor, insira um e-mail válido!');
      return false;
    }

    // Validar Senha
    if (_senhaController.text.length < 8) {
      _showSnackBar('A senha deve ter pelo menos 8 caracteres!');
      return false;
    }

    return true;
  }

  // Função para exibir mensagem de erro
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Função para autenticar o usuário
  Future<void> _login() async {
    if (!_validarCampos()) return;

    setState(() {
      _isLoading = true;
    });

    // Tentar autenticar no Parse
    try {
      final user = ParseUser(_emailController.text, _senhaController.text, null);
      final response = await user.login();

      if (response.success) {
        // Acessar o usuário atual do Parse após o login
        ParseUser currentUser = await ParseUser.currentUser() as ParseUser;
        
        // Obter dados do usuário do Parse (você pode acessar os campos que deseja, como 'name', 'email', etc)
        String userName = currentUser.get<String>('nome') ?? 'Nome não disponível';  // Pega o nome do usuário
        String userEmail = currentUser.get<String>('email') ?? 'Email não disponível'; // Pega o email do usuário

        // Atualiza o UserProvider com os dados do usuário
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(userName, userEmail);

        // Navegar para a tela principal
        Navigator.pushReplacementNamed(context, '/home');
        print('Login realizado com sucesso!');
      } else {
        // Caso haja erro no login
        _showSnackBar('E-mail ou senha incorretos.');
        print('Erro no login: ${response.error!.message}');
      }
    } catch (e) {
      _showSnackBar('Erro ao tentar fazer o login. Tente novamente.');
      print('Erro: $e');
    }

    setState(() {
      _isLoading = false;
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
              'assets/images/Bemvindo.png',
              fit: BoxFit.cover,
            ),
          ),
          // Conteúdo centralizado
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Imagem sobreposta (logo)
                    Center(
                      child: Image.asset(
                        'assets/images/logomarca.png',
                        width: 250,
                        height: 250,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Descrição do Campo de Email
                    const Text(
                      'Informe seu endereço de e-mail',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Campo de Email
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Descrição do Campo de Senha
                    const Text(
                      'Informe sua senha',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Campo de Senha
                    _buildTextField(
                      controller: _senhaController,
                      hintText: 'Senha',
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),

                    // Botão de login
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),  // Chama a função de login
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Entrar',
                            style: TextStyle(
                              color: Color(0xFF802600),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                    ),
                    
                    // Opção de redirecionamento para a tela de cadastro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Não tem conta? '),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/cadastro');
                          },
                          child: const Text(
                            'Cadastre-se',
                            style: TextStyle(
                              color: Color(0xFF802600),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função para construir os campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF802600)),
      ),
      child: Semantics(
        label: hintText,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }
}
