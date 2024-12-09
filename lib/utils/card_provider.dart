import 'package:flutter/material.dart';
import 'package:terracota/utils/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Adiciona item ao carrinho
  void addItem(Product product, int quantity) {
    final existingIndex = _items.indexWhere((item) => item.product.name == product.name);
    
    if (existingIndex >= 0) {
      // Se o item já existir, incrementa a quantidade
      _items[existingIndex].quantity += quantity;
      if (_items[existingIndex].quantity <= 0) {
        // Garantir que a quantidade não seja zero ou negativa
        _items[existingIndex].quantity = 1; // Valor mínimo de 1
      }
    } else {
      // Caso o item não exista, adiciona um novo item no carrinho
      _items.add(CartItem(product: product, quantity: quantity));
    }
    // Notifica os listeners para atualizar a UI
    notifyListeners();
  }

  // Remove item do carrinho
  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.name == product.name);
    // Notifica os listeners para atualizar a UI
    notifyListeners();
  }

  // Calcula o preço total do carrinho
  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  // Conta o número total de itens no carrinho
  int get itemCount {
    int count = 0;
    for (var item in _items) {
      count += item.quantity;
    }
    return count;
  }

  // Limpa o carrinho de compras
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
