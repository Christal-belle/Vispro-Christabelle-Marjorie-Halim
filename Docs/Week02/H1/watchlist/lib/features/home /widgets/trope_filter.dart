import 'package:flutter/material.dart';
import 'package:watchlist/core/theme/app_theme.dart';

class TropeFilter extends StatelessWidget {
  final List<String> tropes;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final bool wrap;

  const TropeFilter({
    super.key,
    required this.tropes,
    required this.selected,
    required this.onToggle,
    this.wrap = false,
  });

  Widget _chip(BuildContext context, String t) {
    final scheme = Theme.of(context).colorScheme;
    final isSelected = selected.contains(t);

    return FilterChip(
      label: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: Text(t, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      selected: isSelected,
      showCheckmark: false,
      selectedColor: AppTheme.accentColor,
      backgroundColor: Colors.transparent,
      side: BorderSide(
        color: isSelected
            ? AppTheme.accentColor
            : scheme.outline.withValues(alpha: 0.5),
      ),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: isSelected ? AppTheme.onAccent : scheme.onSurfaceVariant,
      ),
      onSelected: (_) => onToggle(t),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final chips = [for (final t in tropes) _chip(context, t)];
 
    if (wrap) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(spacing: 8, runSpacing: 8, children: chips),
      );
    }
 
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final c in chips) ...[c, const SizedBox(width: 8)],
        ],
      ),
    );
  }
}
 