import 'package:flutter/material.dart';

class CartManager extends ChangeNotifier {
  final List<String> _items = [];
  final List<Map<String, dynamic>> _history = [];

  String _userName = ''; // 👈 Nuevo: nombre del usuario

  List<String> get items => _items;
  List<Map<String, dynamic>> get history => _history;
  String get userName => _userName;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void addItem(String item) {
    _items.add(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void finalizePurchase() {
    if (_items.isNotEmpty) {
      _history.add({
        'date': DateTime.now().toString().split(' ')[0],
        'products': List.from(_items),
        'total': _items.length * 2.00,
        'user': _userName, // 👈 Aquí se usa el nombre guardado
      });
      clearCart();
      notifyListeners();
    }
  }
}
