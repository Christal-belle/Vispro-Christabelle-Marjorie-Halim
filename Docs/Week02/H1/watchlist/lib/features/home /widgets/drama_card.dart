import 'package:flutter/material.dart';
import 'package:watchlist/core/models/drama.dart';
import 'package:watchlist/core/theme/app_theme.dart';

class DramaCard extends StatelessWidget {
  final Drama drama;
  
  const DramaCard({super.key, required this.drama});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final statusColor = AppTheme.statusColor(drama.status);
    
    final subtitle = [
      if (drama.year != null) '${drama.year}',
      if (drama.genre.isNotEmpty) drama.genre,
    ].join(' • ');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _Poster(path: drama.imagePath),
                Positioned(
                  top: 8,
                  left: 8,
                  child: _Badge(
                    label: drama.status,
                    background: scheme.primary,
                    foreground: AppTheme.onAccent,
                  ),
                ),
                if (drama.rating != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _Badge(
                      label: '★ ${drama.rating!.toStringAsFixed(1)}',
                      background: Colors.black54,
                      foreground: AppTheme.ratingColor,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drama.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: drama.progress,
                    minHeight: 6,
                    color: statusColor,
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${drama.watchedEpisodes}/${drama.episodes} eps'
                  '${drama.unwatchedEpisodes > 0 ? ' • ${drama.unwatchedEpisodes} left' : ''}',
                  style: text.labelSmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  final String? path;
  const _Poster({this.path});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fallback = Container(
      color: scheme.surfaceContainerHighest,
      child: const Center(child: Icon(Icons.movie_outlined, size: 40)),
    );

    if (path == null || path!.isEmpty) return fallback;

    if (path!.startsWith('http')) {
      return Image.network(
        path!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : Container(
                color: scheme.surfaceContainerHighest,
                child: const Center(child: CircularProgressIndicator()),
              ),
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    return Image.asset(
      path!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}