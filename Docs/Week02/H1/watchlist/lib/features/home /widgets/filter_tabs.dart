import 'package:flutter/material.dart';

class FilterTabs extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const FilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _filters = ["All", "Watching", "Completed", "Plan"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SegmentedButton<String>(
        showSelectedIcon: false,
        segments: [
          for (final f in _filters)
            ButtonSegment<String>(value: f, label: Text(f)),
          ],
          selected: {selected},
          onSelectionChanged: (Set<String> s) => onChanged(s.first),
        ),
    );
  }
}