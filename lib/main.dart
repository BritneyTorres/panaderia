import 'package:crud_firebase/cart_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:crud_firebase/screens/home_screen.dart';
import 'package:crud_firebase/screens/purchase_history_screen.dart';
import 'package:crud_firebase/screens/auth/login_screen.dart';
import 'package:crud_firebase/screens/auth/register_screen.dart';
import 'package:crud_firebase/screens/ventas/products_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartManager(),
      child: PanaderiaApp(),
    ),
  );
}

class PanaderiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Panadería',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/products': (context) => ProductsScreen(),
        '/history': (context) => PurchaseHistoryScreen(),
      },
    );
  }
}
