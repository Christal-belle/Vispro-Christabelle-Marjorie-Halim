import 'package:flutter/material.dart';
import 'package:watchlist/core/models/drama.dart';
import 'package:watchlist/features/home /widgets/drama_card.dart';

class DramaList extends StatelessWidget {
  final List<Drama> dramas;
  final Widget emptyState;
  final ValueChanged<Drama>? onTap;

  const DramaList({
    super.key,
    required this.dramas,
    required this.emptyState,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (dramas.isEmpty) {
      return SliverFillRemaining(hasScrollBody: false, child: emptyState);
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),
      itemCount: dramas.length,
      itemBuilder: (context, i) {
          final drama = dramas[i];
          return DramaCard(
            drama: drama,
            onTap: onTap == null ? null : () => onTap!(drama),
          );
        },
      ),
    );
  }
}
 