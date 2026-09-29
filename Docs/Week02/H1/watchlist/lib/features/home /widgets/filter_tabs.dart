import 'package:flutter/material.dart';

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
    final filters = ["All", "Watching", "Completed", "Plan"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: filters.map((f) {
        return ChoiceChip(
          label: Text(f),
          selected: selected == f,
          onSelected: (_) => onChanged(f),
        );
      }).toList(),
    );
  }
}