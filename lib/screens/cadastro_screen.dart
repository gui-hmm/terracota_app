import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:terracota/utils/user_provider.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _contatoController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _isLoading = false;  // Variável para controlar o estado de carregamento
  String _tipoSelecionado = 'cliente';  // Variável para armazenar o tipo selecionado

  // Máscaras
  final _cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});
  final _contatoFormatter = MaskTextInputFormatter(mask: '(##) #####-####', filter: {'#': RegExp(r'[0-9]')});

  // Função de validação
  bool _validarCampos() {
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _tipoSelecionado.isEmpty ||
        _cpfController.text.isEmpty ||
        _contatoController.text.isEmpty ||
        _senhaController.text.isEmpty ||
        _confirmarSenhaController.text.isEmpty) {
      _showSnackBar('Todos os campos precisam ser preenchidos!');
      return false;
    }

    // Validar e-mail
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(_emailController.text)) {
      _showSnackBar('Por favor, insira um e-mail válido!');
      return false;
    }

    // Validar CPF
    if (_cpfController.text.length != 14) {  // Formato do CPF é 000.000.000-00
      _showSnackBar('Por favor, insira um CPF válido!');
      return false;
    }

    // Validar Contato
    if (_contatoController.text.length != 15) {  // Formato do telefone é (00) 00000-0000
      _showSnackBar('Por favor, insira um número de telefone válido!');
      return false;
    }

    // Validar Senha
    if (_senhaController.text != _confirmarSenhaController.text) {
      _showSnackBar('As senhas não coincidem!');
      return false;
    }

    if (_senhaController.text.length < 8) {
      _showSnackBar('A senha deve ter pelo menos 8 caracteres!');
      return false;
    }

    return true;
  }

  // Função para exibir a mensagem de erro
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Função para salvar os dados no Parse
  Future<void> _salvarCadastro() async {
    if (!_validarCampos()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Criar o objeto ParseUser para o cadastro
      final parseUser = ParseUser.createUser(
        _emailController.text.trim(),
        _senhaController.text,
      )
        ..set('nome', _nomeController.text)
        ..set('cpf', _cpfController.text)
        ..set('contato', _contatoController.text)
        ..set('tipo', _tipoSelecionado)
        ..set('email', _emailController.text);

      // Salvar o objeto no Parse
      final response = await parseUser.signUp();
      final user = ParseUser(_emailController.text, _senhaController.text, null);

      if (response.success) {
        // Cadastro bem-sucedido


        // Acessar o usuário atual do Parse após o login
        ParseUser currentUser = await ParseUser.currentUser() as ParseUser;
        // Obter dados do usuário do Parse (você pode acessar os campos que deseja, como 'name', 'email', etc)
        String userName = currentUser.get<String>('nome') ?? 'Nome não disponível';  // Pega o nome do usuário
        String userEmail = currentUser.get<String>('email') ?? 'Email não disponível'; // Pega o email do usuário

        // Atualiza o UserProvider com os dados do usuário
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(userName, userEmail);



        Navigator.pushReplacementNamed(context, '/home');
        print('Cadastro realizado com sucesso!');
      } else {
        // Exibe erro se houver falha ao salvar
        _showSnackBar('Erro ao realizar o cadastro. Tente novamente.');
        print('Erro: ${response.error?.message}');
        if (response.error?.message != null) {
          _showSnackBar('Erro: ${response.error?.message}');
        }
      }
    } catch (e) {
      // Exibe qualquer erro que aconteça durante o cadastro
      print('Erro ao salvar cadastro: $e');
      _showSnackBar('Ocorreu um erro inesperado. Tente novamente.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                  crossAxisAlignment: CrossAxisAlignment.start,  // Alinha as descrições à esquerda
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Logomarca
                    Center(
                      child: Image.asset(
                        'assets/images/logomarca.png',
                        width: 250,
                        height: 250,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Descrição e Campo Nome
                    _buildLabelAndField(
                      label: 'Informe seu nome completo',
                      controller: _nomeController,
                      hintText: 'Nome',
                      accessibilityLabel: 'Nome completo',
                    ),
                    const SizedBox(height: 20),

                    // Descrição e Campo E-mail
                    _buildLabelAndField(
                      label: 'Informe seu e-mail',
                      controller: _emailController,
                      hintText: 'E-mail',
                      keyboardType: TextInputType.emailAddress,
                      accessibilityLabel: 'Endereço de e-mail',
                    ),
                    const SizedBox(height: 30),

                    // Campo Tipo (Dropdown)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFF802600)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButton<String>(
                          value: _tipoSelecionado,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          onChanged: (String? newValue) {
                            setState(() {
                              _tipoSelecionado = newValue!;
                            });
                          },
                          items: <String>['cliente', 'empresa', 'artesão']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Descrição e Campo CPF
                    _buildLabelAndField(
                      label: 'Informe seu CPF',
                      controller: _cpfController,
                      hintText: 'CPF',
                      keyboardType: TextInputType.number,
                      inputFormatters: [_cpfFormatter],
                      accessibilityLabel: 'Número de CPF',
                    ),
                    const SizedBox(height: 20),

                    // Descrição e Campo Contato
                    _buildLabelAndField(
                      label: 'Informe seu número de telefone',
                      controller: _contatoController,
                      hintText: 'Telefone',
                      keyboardType: TextInputType.number,
                      inputFormatters: [_contatoFormatter],
                      accessibilityLabel: 'Número de telefone',
                    ),
                    const SizedBox(height: 20),

                    // Descrição e Campo Senha
                    _buildLabelAndField(
                      label: 'Escolha uma senha',
                      controller: _senhaController,
                      hintText: 'Senha',
                      obscureText: true,
                      accessibilityLabel: 'Senha',
                    ),
                    const SizedBox(height: 20),

                    // Descrição e Campo Confirmar Senha
                    _buildLabelAndField(
                      label: 'Confirme sua senha',
                      controller: _confirmarSenhaController,
                      hintText: 'Confirmar Senha',
                      obscureText: true,
                      accessibilityLabel: 'Confirmar senha',
                    ),
                    const SizedBox(height: 30),

                    // Botão de Cadastro
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _salvarCadastro,
                              child: const Text(
                                'Cadastrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF802600)
                                ),
                              ),
                            ),
                          ),

                    const SizedBox(height: 20),

                    // Redirecionamento para a tela de login
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Já tem uma conta?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child:
                              const Text(
                                'Login',
                                style: TextStyle(color: Color(0xFF802600)),
                              ),
                          ),
                        ],
                      ),
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

  // Função reutilizável para criar o label e o campo de texto
  Widget _buildLabelAndField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    String accessibilityLabel = '',
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label explicativo
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,  // Texto menor
            fontWeight: FontWeight.w400,  // Peso de fonte mais fino
            color: Colors.black54,  // Cor mais suave
          ),
        ),
        const SizedBox(height: 8),
        // Campo de texto
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF802600)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}
