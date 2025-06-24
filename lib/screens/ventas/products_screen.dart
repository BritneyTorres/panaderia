import 'package:flutter/material.dart';
import '../carrito/cart_screen.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
 final List<Map<String, dynamic>> products = [
  {
    'name': 'Pan francés',
    'price': 1.50,
    'image': 'https://trigodeoro.com.pe/wp-content/uploads/2023/02/frances-sandwich.png',
  },
  {
    'name': 'Croissant',
    'price': 2.00,
    'image': 'https://trigodeoro.com.pe/wp-content/uploads/2020/09/pan-croissant-grande.png',
  },
  {
    'name': 'Baguette',
    'price': 1.80,
    'image': 'https://trigodeoro.com.pe/wp-content/uploads/2023/02/Baguette-Clasico.png',
  },
  {
    'name': 'Pan de chocolate',
    'price': 2.50,
    'image': 'https://trigodeoro.com.pe/wp-content/uploads/2023/03/croissant-con-chispas-de-chocolate.png',
  },
  {
    'name': 'Donut glaseado',
    'price': 1.20,
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTueV0-2xdG6B9gi2n2Xtia2SpmFEKLavKkyA&s',
  },
  {
    'name': 'Pan integral',
    'price': 1.90,
    'image': 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRVtX9CBU3vjEQByVphjJ8Smvz2htRXie9h7JFPxlQc2OPK-e0SmVcACzaK4xLPMeegVwDijaqGnwXYnqpcmGl14EKzuREcd04W8U4rH2_j',
  },
  {
    'name': 'Pan de centeno',
    'price': 2.10,
    'image': 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTzQx1GFlH_6S-sX64FlpfqjtAAkF2gK3kuTSU20HOL7YVMPaQs5Oi16FRtZ0VppWE-UIWhYmNR2S_Sxh9Y5zrUil3t_SRMOg-f-E88ni4',
  },
  {
    'name': 'Empanada de manzana',
    'price': 2.30,
    'image': 'https://trigodeoro.com.pe/wp-content/uploads/2021/06/Pie-de-manzana.png',
  },
  {
    'name': 'Pan brioche',
    'price': 2.00,
    'image': 'https://trigodeoro.com.pe/wp-content/uploads/2021/04/Briochecitos.png',
  },
  {
    'name': 'Pan pita',
    'price': 1.70,
    'image': 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTT3JAPkfqpiiUqLqsz5-3PSLy6d0evk7qV7EKbx5xeYhWxH_IW6YmAVNtf8a3-mPITCidASurX5Vg_kDc3AKh_bgY1Y8og4N3q4C27hrh9',
  },
  {
    'name': 'Pan de ajo',
    'price': 2.40,
    'image': 'https://wongfood.vtexassets.com/arquivos/ids/554375-1200-auto?v=637904804301770000&width=1200&height=auto&aspect=true',
  },
  {
    'name': 'Pan de molde',
    'price': 1.60,
    'image': 'https://trigodeoro.com.pe/wp-content/uploads/2021/06/pan-de-molde-de-leche-snack.png',
  },
  {
    'name': 'Pan ciabatta',
    'price': 2.20,
    'image': 'https://trigodeoro.com.pe/wp-content/uploads/2023/02/Ciabatta-Grande.png',
  },
  {
    'name': 'Muffin de arándanos',
    'price': 2.10,
    'image': 'https://guaioio.cl/wp-content/uploads/2020/09/muffins-chips-chocolate-2-1-768x512.jpg',
  },
];



  List<Map<String, dynamic>> cartItems = [];

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      int index = cartItems.indexWhere((item) => item['name'] == product['name']);
      if (index >= 0) {
        cartItems[index]['quantity']++;
      } else {
        cartItems.add({...product, 'quantity': 1});
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} agregado al carrito')),
    );
  }

  void increaseQuantity(String productName) {
    setState(() {
      int index = cartItems.indexWhere((item) => item['name'] == productName);
      if (index >= 0) {
        cartItems[index]['quantity']++;
      }
    });
  }

  void decreaseQuantity(String productName) {
    setState(() {
      int index = cartItems.indexWhere((item) => item['name'] == productName);
      if (index >= 0) {
        if (cartItems[index]['quantity'] > 1) {
          cartItems[index]['quantity']--;
        } else {
          cartItems.removeAt(index);
        }
      }
    });
  }

  int getQuantity(String productName) {
    int index = cartItems.indexWhere((item) => item['name'] == productName);
    if (index >= 0) {
      return cartItems[index]['quantity'];
    }
    return 0;
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cartItems: cartItems,
          onCartChanged: (updatedCart) {
            setState(() {
              cartItems = updatedCart;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        backgroundColor: Colors.brown[400], 
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: openCart,
          )
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(12),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          final quantity = getQuantity(product['name']);
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      product['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product['name'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\$${product['price'].toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: quantity == 0
                      ? ElevatedButton(
                          onPressed: () => addToCart(product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Agregar'),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () => decreaseQuantity(product['name']),
                            ),
                            Text(quantity.toString(), style: TextStyle(fontSize: 16)),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () => increaseQuantity(product['name']),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
