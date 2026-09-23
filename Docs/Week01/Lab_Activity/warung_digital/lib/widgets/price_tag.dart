import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String menu;
  final int price;
  final int stock;

  const PriceTag({
    super.key,
    required this.menu,
    required this.price,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSoldOut = stock == 0;

    return Card(
      child: ListTile(
        title: Text(menu),
        subtitle: Text(
          isSoldOut ? 'Sold Out' : 'Stock: $stock',
          style: TextStyle(
            color: isSoldOut ? Colors.red : Colors.black,
          ),
        ),
        trailing: Text(
          'Rp $price',
          style: TextStyle(
            color: isSoldOut ? Colors.grey : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}