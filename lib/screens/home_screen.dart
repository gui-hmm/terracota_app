import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terracota/utils/card_provider.dart';
import 'package:terracota/utils/product.dart';
import 'package:terracota/utils/user_provider.dart'; // Importe o UserProvider aqui

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // GlobalKey para o Scaffold
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Lista de produtos de exemplo
  final List<Product> products = [
    Product(imageUrl: 'assets/images/p1.png', name: 'Vasos de cerâmica', price: 160.00),
    Product(imageUrl: 'assets/images/p2.png', name: 'Panela de barro', price: 145.00),
    Product(imageUrl: 'assets/images/p3.png', name: 'Estatueta de terracota', price: 350.00),
    Product(imageUrl: 'assets/images/p4.png', name: 'Caldeirão de barro', price: 160.00),
    Product(imageUrl: 'assets/images/p5.png', name: 'Potes de barro', price: 145.00),
    Product(imageUrl: 'assets/images/p6.png', name: 'Tigelas de cerâmica', price: 145.00),
    Product(imageUrl: 'assets/images/p7.png', name: 'Leão de barro', price: 300.00),
    Product(imageUrl: 'assets/images/p8.png', name: 'Cervos de cerâmica', price: 500.00),
    Product(imageUrl: 'assets/images/p9.png', name: 'São Francisco', price: 250.00),
    Product(imageUrl: 'assets/images/p10.png', name: 'Jarra de cerâmica', price: 150.00),
    Product(imageUrl: 'assets/images/p11.png', name: 'Cisnes de cerâmica', price: 200.00),
    Product(imageUrl: 'assets/images/p12.png', name: 'Coelho de barro', price: 130.00),
  ];

  // Função para mostrar o diálogo de quantidade do produto
  void _showQuantityDialog(BuildContext context, Product product) {
    int quantity = 1;  // Quantidade inicial do produto

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecionar Quantidade'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Exibir a imagem do produto
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product.imageUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Nome e preço do produto
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  // Controle de quantidade
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Adicionar o produto ao carrinho
                final cartProvider = Provider.of<CartProvider>(context, listen: false);
                cartProvider.addItem(product, quantity);

                // Fechar o diálogo
                Navigator.pop(context);
              },
              child: const Text('Adicionar ao Carrinho'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Fechar o diálogo
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);  // Acessando o UserProvider

    return Scaffold(
      key: scaffoldKey, // Usando o GlobalKey para controlar o Scaffold
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Consumer<UserProvider>(  // Usando o Consumer para escutar as mudanças no UserProvider
              builder: (context, userProvider, child) {
                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF802600),
                  ),
                  accountName: Text(userProvider.name),  // Exibe o nome do usuário
                  accountEmail: Text(userProvider.email),  // Exibe o email do usuário
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                );
              },
          ),
            _buildDrawerItem(context, Icons.person, 'Perfil', '/perfil'),
            _buildDrawerItem(context, Icons.payment, 'Pagamentos', '/pagamentos'),
            _buildDrawerItem(context, Icons.notifications, 'Notificações', '/notificacoes'),
            _buildDrawerItem(context, Icons.security, 'Segurança', '/seguranca'),
            _buildDrawerItem(context, Icons.help, 'Ajuda e Suporte', '/ajuda'),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: () {
                // Resetando os dados do usuário no UserProvider
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                userProvider.resetUser();

                // Redireciona para a tela de login
                Navigator.pushReplacementNamed(context, '/login');
                
                // Mensagem informando que o usuário saiu
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saindo do aplicativo...')),
                );
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 170.0,
            floating: true,
            pinned: true,
            backgroundColor: Color(0xFF802600),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
            ),
            title: Center(
              child: Container(
                child: Image.asset(
                  'assets/images/logomarca_clara.png',
                  height: 55,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Container(
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                bool isCollapsed = constraints.maxHeight < 168;

                return FlexibleSpaceBar(
                  title: isCollapsed
                      ? Container() // Quando colapsado, não mostrar título
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 40.0, top: 85.0),
                                child: Text(
                                  'Explore nossa coleção de artesanato!',
                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(right: 40.0),
                                child: Container(
                                  width: 220,
                                  height: 35,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 5),
                                      prefixIcon: const Icon(Icons.search),
                                      hintText: 'Buscar produtos...',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(right: 180.0, left: 32.0, top: 10.0),
              child: Text(
                'Mais Vendidos',
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Color(0xff802600)),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final product = products[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => _showQuantityDialog(context, product),
                      child: ProductCard(product: product),
                    ),
                  );
                },
                childCount: products.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (MediaQuery.of(context).size.width / 200).floor(),
                crossAxisSpacing: 14.0,
                mainAxisSpacing: 14.0,
                childAspectRatio: 0.75,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para criar itens do menu lateral
  ListTile _buildDrawerItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFFFFFF),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.asset(
                product.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  'R\$ ${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14, color: Color(0xff000000)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
