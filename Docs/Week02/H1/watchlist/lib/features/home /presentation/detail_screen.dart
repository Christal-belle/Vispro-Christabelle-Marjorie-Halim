import 'package:flutter/material.dart';
import 'package:watchlist/core/layout/breakpoints.dart';
import 'package:watchlist/core/models/drama.dart';
import 'package:watchlist/core/theme/app_theme.dart';
import 'package:watchlist/features/home /widgets/poster_image.dart';

class DetailScreen extends StatelessWidget {
  final Drama drama;

  const DetailScreen({super.key, required this.drama});

  static Future<void> open(BuildContext context, Drama drama) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => DetailScreen(drama: drama)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= kTabletBreakpoint) {
          return _tablet(context, constraints.maxWidth);
        }
        return _phone(context);
      },
    );
  }

  Widget _phone(BuildContext context) {
    final headerHeight =
      (MediaQuery.sizeOf(context).height * 0.55).clamp(300.0, 520.0);

    return Scaffold(
      body: CustomScrollView(
        key: const Key('detail-phone-layout'),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: headerHeight,
            backgroundColor: AppTheme.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PosterImage(
                    path: drama.imagePath,
                    alignment: Alignment.topCenter,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black45,
                          Colors.transparent,
                          Colors.transparent,
                          AppTheme.backgroundColor,
                        ],
                        stops: [0, 0.2, 0.75, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _DetailBody(drama: drama),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tablet(BuildContext context, double width) {
    final posterPane = (width * 0.35).clamp(240.0, 320.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(drama.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SafeArea(
        child: Row(
          key: const Key('detail-tablet-layout'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: posterPane,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: PosterImage(
                      path: drama.imagePath,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 24),
                child: _DetailBody(drama: drama),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final Drama drama;

  const _DetailBody({required this.drama});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final statusColor = AppTheme.statusColor(drama.status);

    final subtitle = [
      if (drama.year != null) '${drama.year}',
      if (drama.genre.isNotEmpty) drama.genre,
    ].join(' • ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          drama.title,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: text.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              label: Text(drama.status),
              backgroundColor: statusColor,
              labelStyle: text.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.onAccent,
              ),
              side: BorderSide.none,
            ),
            if (drama.rating != null)
              Chip(
                label: Text('★ ${drama.rating!.toStringAsFixed(1)}'),
                backgroundColor: Colors.black54,
                labelStyle: text.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.ratingColor,
                ),
                side: BorderSide.none,
              ),
          ],
        ),
        const SizedBox(height: 24),
        const _SectionTitle('Synopsis'),
        _Synopsis(text: drama.synopsis),
        const SizedBox(height: 24),
        const _SectionTitle('Progress'),
        LinearProgressIndicator(
          value: drama.progress,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
          color: statusColor,
          backgroundColor: scheme.surfaceContainerHighest,
        ),
        const SizedBox(height: 8),
        Text(
          '${drama.watchedEpisodes} of ${drama.episodes} episodes watched'
          '${drama.unwatchedEpisodes > 0 ? ' · ${drama.unwatchedEpisodes} left' : ''}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 24),
        const _SectionTitle('Watch time'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    label: 'Watched',
                    value: formatDuration(drama.watchedMinutes),
                  ),
                ),
                Expanded(
                  child: _InfoTile(
                    label: 'Total',
                    value:
                        formatDuration(drama.episodes * drama.episodeDuration),
                  ),
                ),
                Expanded(
                  child: _InfoTile(
                    label: 'Per episode',
                    value: '${drama.episodeDuration} min',
                  ),
                ),
              ],
            ),
          ),
        ),
        if (drama.tropes.isNotEmpty) ...[
          const SizedBox(height: 24),
          const _SectionTitle('Tropes'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in drama.tropes)
                Chip(
                  label: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 240),
                    child: Text(
                      t,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  backgroundColor:
                      AppTheme.accentColor.withValues(alpha: 0.16),
                  side: BorderSide(
                    color: AppTheme.accentColor.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Synopsis extends StatefulWidget {
  final String text;

  const _Synopsis({required this.text});

  @override
  State<_Synopsis> createState() => _SynopsisState();
}

class _SynopsisState extends State<_Synopsis> {
  static const int _collapsedLines = 4;
  static const int _longThreshold = 180;

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    if (widget.text.trim().isEmpty) {
      return Text(
        'No synopsis yet.',
        key: const Key('synopsis-empty'),
        style: text.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
          color: scheme.onSurfaceVariant,
        ),
      );
    }

    final isLong = widget.text.length > _longThreshold;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: Text(
            widget.text,
            key: const Key('synopsis-text'),
            maxLines: expanded ? null : _collapsedLines,
            overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: text.bodyMedium?.copyWith(
              height: 1.5,
              color: scheme.onSurface.withValues(alpha: 0.87),
            ),
          ),
        ),
        if (isLong)
          TextButton(
            key: const Key('synopsis-toggle'),
            onPressed: () => setState(() => expanded = !expanded),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 36),
              alignment: Alignment.centerLeft,
            ),
            child: Text(expanded ? 'Show less' : 'Read more'),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}