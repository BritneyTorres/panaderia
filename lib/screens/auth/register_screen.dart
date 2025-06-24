import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: Row(
            children: const [
              Icon(Icons.bakery_dining, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Registro de cliente',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  'https://img.freepik.com/vector-gratis/texto-fresco-delicioso-panaderia-diseno-pancartas-o-carteles_1308-128241.jpg?ga=GA1.1.1959286622.1731249059&semt=ais_items_boosted&w=740',
                  height: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  '¡Bienvenido a la panadería!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
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
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    if (name.isEmpty) {
                      scaffoldKey.currentState!.showSnackBar(
                        const SnackBar(
                          content: Text('Por favor ingresa tu nombre completo'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

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
                      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      final userId = userCredential.user!.uid;

                      await FirebaseFirestore.instance.collection('usuarios').doc(userId).set({
                        'nombre': name,
                        'email': email,
                        'creado': Timestamp.now(),
                      });

                      scaffoldKey.currentState!.showSnackBar(
                        const SnackBar(
                          content: Text('Registro exitoso 🎉'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                      });
                    } catch (e) {
                      scaffoldKey.currentState!.showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '¿Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
