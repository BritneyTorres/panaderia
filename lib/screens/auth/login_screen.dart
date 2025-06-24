import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_firebase/cart_manager.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: const Row(
            children: [
              Icon(Icons.bakery_dining, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Inicio de Sesión',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    'https://img.freepik.com/vector-gratis/texto-fresco-delicioso-panaderia-diseno-pancartas-o-carteles_1308-128241.jpg?ga=GA1.1.1959286622.1731249059&semt=ais_items_boosted&w=740',
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Bienvenido a la panadería',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[600],
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (!RegExp(r"^[\w-\.]+@gmail\.com$").hasMatch(email)) {
                        scaffoldKey.currentState!.showSnackBar(
                          const SnackBar(
                            content: Text('Correo no válido. Solo se acepta @gmail.com'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (password.length < 6) {
                        scaffoldKey.currentState!.showSnackBar(
                          const SnackBar(
                            content: Text('La contraseña debe tener al menos 6 caracteres'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        final user = FirebaseAuth.instance.currentUser;

                        if (user != null) {
                          final userDoc = FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
                          final snapshot = await userDoc.get();

                          if (snapshot.exists) {
                            final userName = snapshot.data()!['nombre'] ?? 'Cliente';
                            Provider.of<CartManager>(context, listen: false).setUserName(userName);
                          } else {
                            await userDoc.set({
                              'correo': user.email,
                              'creado': Timestamp.now(),
                              'nombre': 'Cliente',
                            });
                            Provider.of<CartManager>(context, listen: false).setUserName('Cliente');
                          }
                        }

                        Navigator.pushReplacementNamed(context, '/home');
                      } catch (e) {
                        scaffoldKey.currentState!.showSnackBar(
                          SnackBar(
                            content: Text('Error al iniciar sesión: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Ingresar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      '¿No tienes cuenta? Regístrate',
                      style: TextStyle(color: Colors.brown[700]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
