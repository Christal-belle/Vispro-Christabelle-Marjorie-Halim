import 'package:flutter/material.dart';
import 'package:watchlist/core/theme/app_theme.dart';

class FilterTabs extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const FilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = const["All", "Watching", "Completed", "Plan"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: filters.map((f) {
        final isSelected = selected == f;
        final color = AppTheme.statusColor(f);

        return ChoiceChip(
          label: Text(f),
          selected: isSelected,
          showCheckmark: false,
          selectedColor: color,
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: isSelected ? color : color.withValues(alpha: 0.5),
          ),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppTheme.onAccent : color,
          ),
          onSelected: (_) => onChanged(f),
        );
      }).toList(),
    );
  }
}