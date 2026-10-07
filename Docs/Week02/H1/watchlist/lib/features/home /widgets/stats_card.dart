import 'package:flutter/material.dart';
import 'package:watchlist/core/models/drama.dart';

class StatsCard extends StatelessWidget {
  final List<Drama> dramas;
  const StatsCard({super.key, required this.dramas});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final totalMinutes = dramas.fold<int>(0, (s, d) => s + d.watchedMinutes);
    final watched = dramas.fold<int>(0, (s, d) => s + d.watchedEpisodes);
    final unwatched = dramas.fold<int>(0, (s, d) => s + d.unwatchedEpisodes);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total watch time',
                    style: text.labelMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDuration(totalMinutes),
                    style: text.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            _Stat(label: 'Ditonton', value: '$watched', context: context),
            const SizedBox(width: 20),
            _Stat(label: 'Belum', value: '$unwatched', context: context),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;
  const _Stat({
    required this.label,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext _) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value,
            style: text.titleMedium?.copyWith(
                fontWeight: FontWeight.w700, color: scheme.primary)),
        Text(label,
            style: text.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}