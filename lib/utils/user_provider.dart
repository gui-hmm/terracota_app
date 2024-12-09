import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _name = "Gui Has Algu";
  String _email = "guihas@example.com";

  String get name => _name;
  String get email => _email;

  // Método para atualizar os dados do usuário
  void updateUser(String newName, String newEmail) {
    _name = newName;
    _email = newEmail;
    notifyListeners();
  }

  // Método para resetar os dados do usuário
  void resetUser() {
    _name = ''; // ou pode deixar como null, dependendo de sua lógica
    _email = ''; // ou null
    notifyListeners();
  }
}
