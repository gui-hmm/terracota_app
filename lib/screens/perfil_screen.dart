import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _contatoController = TextEditingController();
  String _tipoSelecionado = '';

  bool _isEditing = false;
  bool _isLoading = true;

  // Lista de opções para o dropdown
  final List<String> _tipos = ['Cliente', 'Artesão', 'Empresa'];

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Carregar os dados do usuário assim que a tela for iniciada
  }

  Future<void> _loadUserData() async {
    try {
      ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      if (user != null) {
        _nomeController.text = user.get<String>('nome') ?? '';
        _emailController.text = user.get<String>('email') ?? '';
        _cpfController.text = user.get<String>('cpf') ?? '';
        _contatoController.text = user.get<String>('contato') ?? '';
        _tipoSelecionado = user.get<String>('tipo') ?? 'Cliente'; // Definir um valor padrão
      }
    } catch (e) {
      print('Erro ao carregar os dados do usuário: $e');
    } finally {
      setState(() {
        _isLoading = false; // Terminou de carregar
      });
    }
  }

  // Validação dos campos
  bool _validarCampos() {
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _tipoSelecionado.isEmpty ||
        _cpfController.text.isEmpty ||
        _contatoController.text.isEmpty) {
      _showSnackBar('Por favor, preencha todos os campos obrigatórios.');
      return false;
    }

    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _salvarAlteracoes() async {
    if (!_validarCampos()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      ParseUser? user = await ParseUser.currentUser() as ParseUser?;

      

      if (user != null) {
        user.set('nome', _nomeController.text);
        user.set('email', _emailController.text);
        user.set('cpf', _cpfController.text);
        user.set('contato', _contatoController.text);
        user.set('tipo', _tipoSelecionado); // Salvar o tipo selecionado

        final response = await user.save();

        if (response.success) {
          _showSnackBar('Informações atualizadas com sucesso!');
          setState(() {
            _isEditing = false;
          });
        } else {
          _showSnackBar('Erro ao salvar as alterações. Tente novamente.');
        }
      }
    } catch (e) {
      print('Erro ao salvar as alterações: $e');
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF802600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp, color: Color(0xFFFFFFFF)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Perfil', style: TextStyle(color: Color(0xFFFFFFFF))),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Center(
                    child: Container(
                      width: 120,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/images/eu.jpg'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildInfoField(label: 'Nome', controller: _nomeController),
                  const SizedBox(height: 15),
                  _buildInfoField(label: 'Email', controller: _emailController),
                  const SizedBox(height: 15),

                  // Exibição do campo "Tipo" sempre, com borda nas opções do Dropdown
                  DropdownButtonFormField<String>(
                    value: _tipos.contains(_tipoSelecionado)
                        ? _tipoSelecionado
                        : 'Cliente', // Valor padrão se não for válido
                    decoration: InputDecoration(
                      labelText: 'Tipo',
                      hintText: 'Selecione o tipo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _isEditing ? Colors.blue : Color(0xFF802600), // Alterar a borda quando em edição
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFF802600), width: 2), // Cor da borda em foco
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _isEditing ? Color(0xFF802600) : Colors.grey, // Cor da borda baseada no estado de edição
                          width: 2, // Largura da borda
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    onChanged: _isEditing
                        ? (String? newValue) {
                            setState(() {
                              _tipoSelecionado = newValue!;
                            });
                          }
                        : null, // Só permite alterar quando em edição
                    items: _tipos.map((tipo) {
                      return DropdownMenuItem<String>(
                        value: tipo,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(tipo),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 15),

                  _buildInfoField(label: 'CPF', controller: _cpfController),
                  const SizedBox(height: 15),
                  _buildInfoField(label: 'Contato', controller: _contatoController),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_isEditing) {
                          _salvarAlteracoes();
                        }
                        _isEditing = !_isEditing;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF802600),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      _isEditing ? 'Salvar' : 'Editar',
                      style: const TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Digite seu $label',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF802600)), // Cor padrão da borda
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF802600), width: 2), // Cor da borda quando o campo estiver em foco
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF802600), width: 2), // Cor da borda quando o campo estiver habilitado
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
