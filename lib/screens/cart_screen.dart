import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importando o provider
import 'package:terracota/utils/card_provider.dart'; // Importando o CartProvider

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtendo o CartProvider
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF802600),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Color(0xFFFFFFFF),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Carrinho',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 150),
                  Container(
                    child: const Text(
                      'O carrinho está vazio.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Lista de itens do carrinho
                  for (var cartItem in cartItems)
                    CartItemWidget(
                      cartItem: cartItem,
                      onQuantityChanged: (newQuantity) {
                        if (newQuantity == 0) {
                          cartProvider.removeItem(cartItem.product); // Remove item quando quantidade chega a 0
                        } else {
                          cartProvider.addItem(cartItem.product, newQuantity - cartItem.quantity);
                        }
                      },
                    ),
                  // Total e botão de checkout
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total: R\$ ${cartProvider.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Botões lado a lado
                            ElevatedButton(
                              onPressed: () {
                                cartProvider.clearCart(); // Limpar o carrinho
                              },
                              child: Text(
                                'Esvaziar Carrinho',
                                style: TextStyle(
                                  fontSize: 16, 
                                  color: Colors.white
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF802600),
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                textStyle: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)), // Texto branco
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/finalizado');
                              },
                              child: Text(
                                'Finalizar Compra', 
                                style: TextStyle(
                                  fontSize: 16, 
                                  color: Colors.white
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                iconColor: Color(0xFFFFFFFF),
                                backgroundColor: Color(0xFF802600),
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final ValueChanged<int> onQuantityChanged; // Função para alterar a quantidade

  const CartItemWidget({required this.cartItem, required this.onQuantityChanged});

  @override
  Widget build(BuildContext context) {
    double itemTotal = cartItem.product.price * cartItem.quantity; // Calculando o total de cada item

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Image.asset(cartItem.product.imageUrl, width: 50, height: 50),
        title: Text(cartItem.product.name),
        subtitle: Text('R\$ ${cartItem.product.price.toStringAsFixed(2)} x ${cartItem.quantity} = Total: R\$ ${itemTotal.toStringAsFixed(2)}'),
        trailing: Container(
          // Garantir que o trailing tenha altura suficiente
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza os elementos no trailing
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Controle de quantidade no carrinho
              Row(
                mainAxisSize: MainAxisSize.min, // Impede que ocupe o espaço todo
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (cartItem.quantity >= 1) {
                        onQuantityChanged(cartItem.quantity - 1);
                      }
                    },
                  ),
                  Text(cartItem.quantity.toString(), style: TextStyle(fontSize: 16)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      onQuantityChanged(cartItem.quantity + 1);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
