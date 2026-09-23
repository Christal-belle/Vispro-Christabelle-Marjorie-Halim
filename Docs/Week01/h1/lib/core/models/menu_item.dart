class MenuItem {
  final String name;
  final int price;
  final double? discountPercent;

  MenuItem({
    required this.name,
    required this.price,
    this.discountPercent,
  });

  int finalPrice() {
    final discount = discountPercent ?? 0;
    return (price * (1 - discount)).toInt();
  }
}