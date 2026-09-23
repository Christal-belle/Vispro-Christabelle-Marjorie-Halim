import 'package:h1/core/models/menu_item.dart'; 

void main() {
  final items = [
    MenuItem(name: 'Nasi Goreng', price: 15000),
    MenuItem(name: 'Mie Bebek', price: 12000, discountPercent: 0,1),
    MenuItem(name: 'Teh Panas', price: 5000),
  ];

  final names = items.map((item) => item.name).toList();
  print(names);

  final cheapItems = items.where((item) => item.price < 15000).toList();
  print(cheapItems.map((e) => e.name).toList());

  final total = items.fold(0, (sum, item) => sum + item.finalPrice());
  print(total);
}


//penulisan kode dipandu oleh ChatGPT