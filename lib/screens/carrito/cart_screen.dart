import 'package:crud_firebase/cart_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(List<Map<String, dynamic>>) onCartChanged;

  CartScreen({super.key, required this.cartItems, required this.onCartChanged});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = List<Map<String, dynamic>>.from(widget.cartItems);
  }

  double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }

  void updateCart() {
    widget.onCartChanged(cartItems);
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
      updateCart();
    });
  }

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
      updateCart();
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
        updateCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context, listen: false);
    final userName = cartManager.userName.isNotEmpty ? cartManager.userName : 'Cliente Anónimo';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text('🧾 Boleta de Compra'),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'El carrito está vacío 🍞',
                style: TextStyle(fontSize: 18, color: Colors.brown),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['name'],
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      'S/ ${item['price'].toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle_outline),
                                          onPressed: () => decreaseQuantity(index),
                                        ),
                                        Text(item['quantity'].toString()),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle_outline),
                                          onPressed: () => increaseQuantity(index),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                                      onPressed: () => removeItem(index),
                                    ),
                                  ],
                                ),
                                const Divider(thickness: 1),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.brown[100],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown[800]),
                      ),
                      Text(
                        'S/ ${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown[900]),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.payment, color: Colors.brown),
                    label: const Text(
                      'Pagar',
                      style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Colors.brown),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () async {
                      if (cartItems.isNotEmpty) {
                        try {
                          final compra = {
                            'fecha': Timestamp.now(),
                            'productos': cartItems.map((item) => {
                                  'nombre': item['name'],
                                  'cantidad': item['quantity'],
                                  'precio': item['price'],
                                }).toList(),
                            'total': totalPrice,
                            'usuario': userName,
                          };

                          await FirebaseFirestore.instance.collection('compras').add(compra);

                          cartManager.history.add({
                            'date': DateTime.now().toString().split(' ')[0],
                            'products': cartItems.map((item) => '${item['name']} x${item['quantity']}').toList(),
                            'total': totalPrice,
                            'user': userName,
                          });

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('✅ Compra realizada'),
                              content: const Text('Gracias por su compra.\n¡Vuelva pronto a la panadería! 🥐'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      cartItems.clear();
                                      updateCart();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                )
                              ],
                            ),
                          );
                        } catch (e) {
                          print('❌ Error al guardar en Firebase: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al guardar la compra: $e')),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
