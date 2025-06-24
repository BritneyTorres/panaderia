import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../cart_manager.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<CartManager>(context).history;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text('Historial de Compras'),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'Aún no hay compras.',
                style: TextStyle(fontSize: 18, color: Colors.brown),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  color: Colors.white,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Compra del ${item['date']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.brown[800],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Productos: ${item['products'].join(', ')}',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Total: S/ ${item['total'].toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
