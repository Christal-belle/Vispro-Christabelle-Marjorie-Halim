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
                  child: Chip(
                    label: Text(drama.status),
                    backgroundColor: statusColor,
                    labelStyle: text.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onAccent,
                    ),
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  ),
                ),
                if (drama.rating != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Chip(
                      label: Text('★ ${drama.rating!.toStringAsFixed(1)}'),
                      backgroundColor: Colors.black54,
                      labelStyle: text.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.ratingColor,
                      ),
                      side: BorderSide.none,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
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
                LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(4),
                    value: drama.progress,
                    minHeight: 6,
                    color: statusColor,
                    backgroundColor: scheme.surfaceContainerHighest,
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