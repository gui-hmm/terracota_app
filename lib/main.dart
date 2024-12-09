import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:terracota/screens/ajuda_screen.dart';
import 'package:terracota/screens/cadastro_screen.dart';
import 'package:terracota/screens/cart_screen.dart';
import 'package:terracota/screens/compraFinalizada_screen.dart';
import 'package:terracota/screens/notificacoes_screen.dart';
import 'package:terracota/screens/pagamentos_screen.dart';
import 'package:terracota/screens/perfil_screen.dart';
import 'package:terracota/screens/seguranca_screen.dart';
import 'package:terracota/utils/card_provider.dart';
import 'package:terracota/utils/user_provider.dart';  
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  // Carregar as variáveis de ambiente
  await dotenv.load();

  // Inicializar o Parse com as variáveis do .env
  await Parse().initialize(
    dotenv.env['PARSE_APP_ID']!,
    dotenv.env['PARSE_SERVER_URL']!,
    clientKey: dotenv.env['PARSE_CLIENT_KEY']!,
    debug: true,
  );

  runApp(
    MultiProvider(
      providers: [ 
        ChangeNotifierProvider(create: (context) => UserProvider()),  
        ChangeNotifierProvider(create: (context) => CartProvider()), 
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/home': (context) => HomeScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/pagamentos': (context) => const PagamentosScreen(),
        '/notificacoes': (context) => const NotificacoesScreen(),
        '/seguranca': (context) => const SegurancaScreen(),
        '/ajuda': (context) => const AjudaScreen(),
        '/cart': (context) => const CartScreen(),
        '/finalizado': (context) => const OrderConfirmationScreen(),
      },
    );
  }
}
