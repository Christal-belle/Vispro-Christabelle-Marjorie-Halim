import 'package:flutter/material.dart';
import 'package:watchlist/core/theme/app_theme.dart';

class TropeFilter extends StatelessWidget {
  final List<String> tropes;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const TropeFilter({
    super.key,
    required this.tropes,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tropes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final t = tropes[i];
          final isSelected = selected.contains(t);

          return FilterChip(
            label: Text(t),
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
        },
      ),
    );
  }
}