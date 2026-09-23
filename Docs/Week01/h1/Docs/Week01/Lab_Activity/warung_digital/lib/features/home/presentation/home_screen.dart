import 'package:flutter/material.dart';
import 'package:warung_digital/widgets/price_tag.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Warung Digital')),
      body: ListView(
        children: const [
          PriceTag(menu: 'Nasi Goreng', price: 45000, stock: 10),
          PriceTag(menu: 'Soto Ayam', price: 30000, stock: 5),
          PriceTag(menu: 'Kerupuk Emas', price: 2878000, stock: 0),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}