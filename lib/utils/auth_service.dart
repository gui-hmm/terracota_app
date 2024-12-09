import 'package:shared_preferences/shared_preferences.dart';

// Função para verificar o status de login
Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;  // Retorna o valor salvo ou false
}

// Função para salvar o status de login
Future<void> saveLoginStatus(bool isLoggedIn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', isLoggedIn);  // Salva o status de login
}
