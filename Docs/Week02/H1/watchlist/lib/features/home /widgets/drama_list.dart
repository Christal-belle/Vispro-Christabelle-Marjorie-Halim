import 'package:flutter/material.dart';
import 'package:watchlist/core/models/drama.dart';
import 'package:watchlist/features/home /widgets/drama_card.dart';

class DramaList extends StatelessWidget {
  final List<Drama> dramas;

  const DramaList({
    super.key,
    required this.dramas,
  });

  @override
  Widget build(BuildContext context) {
    if (dramas.isEmpty) {
      return const Center(
        child: Text("No dramas found"),
      );
    }

    return ListView.builder(
      itemCount: dramas.length,
      itemBuilder: (context, index) {
        return DramaCard(drama: dramas[index]);
      },
    );
  }
}