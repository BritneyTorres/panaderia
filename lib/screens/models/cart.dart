import 'cart_item.dart';
import 'product.dart';

class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addProduct(Product product) {
    // Si el producto ya está en el carrito, aumenta la cantidad
    for (var item in _items) {
      if (item.product.name == product.name) {
        item.quantity++;
        return;
      }
    }
    // Si no está, lo agrega como nuevo
    _items.add(CartItem(product: product));
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.name == product.name);
  }

  void decreaseQuantity(Product product) {
    for (var item in _items) {
      if (item.product.name == product.name) {
        if (item.quantity > 1) {
          item.quantity--;
        } else {
          removeProduct(product);
        }
        return;
      }
    }
  }

  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.totalPrice;
    }
    return total;
  }

  void clear() {
    _items.clear();
  }

  bool get isEmpty => _items.isEmpty;
}
