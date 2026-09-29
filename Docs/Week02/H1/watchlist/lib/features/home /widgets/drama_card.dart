import 'package:flutter/material.dart';
import 'package:watchlist/core/models/drama.dart';

class DramaCard extends StatelessWidget {
  final Drama drama;

  const DramaCard({
    super.key,
    required this.drama,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: Text(drama.title),
        subtitle: Text(drama.status),
      ),
    );
  }
}