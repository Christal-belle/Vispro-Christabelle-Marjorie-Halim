import 'package:flutter/material.dart';
import 'package:watchlist/core/data/drama_data.dart';
import 'package:watchlist/core/layout/breakpoints.dart';
import 'package:watchlist/core/models/drama.dart';
import 'package:watchlist/core/theme/app_theme.dart';
import 'package:watchlist/features/home /presentation/detail_screen.dart';
import 'package:watchlist/features/home /widgets/drama_list.dart';
import 'package:watchlist/features/home /widgets/empty_state.dart';
import 'package:watchlist/features/home /widgets/filter_tabs.dart';
import 'package:watchlist/features/home /widgets/stats_card.dart';
import 'package:watchlist/features/home /widgets/trope_filter.dart';

class FilterScreen extends StatefulWidget {
  final List<Drama>? dramas;

  const FilterScreen({super.key, this.dramas});

  static Future<void> open(BuildContext context, List<Drama> dramas) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => FilterScreen(dramas: dramas)),
    );
  }

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedFilter = "All";
  String query = '';
  final Set<String> selectedTropes = {};
  final TextEditingController _searchController = TextEditingController();

  late final List<Drama> allDramas = List.of(widget.dramas ?? kDramas);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get allTropes {
    final set = <String>{for (final d in allDramas) ...d.tropes};
    return set.toList()..sort();
  }

  bool get hasActiveFilters =>
      selectedFilter != "All" || selectedTropes.isNotEmpty || query.isNotEmpty;

  List<Drama> get filteredDramas {
    final q = query.toLowerCase();
    return allDramas.where((d) {
      final statusOk = selectedFilter == "All" || d.status == selectedFilter;
      final tropeOk =
          selectedTropes.isEmpty || selectedTropes.every(d.tropes.contains);
      final queryOk = q.isEmpty || d.title.toLowerCase().contains(q);
      return statusOk && tropeOk && queryOk;
    }).toList();
  }

  void updateFilter(String filter) {
    setState(() => selectedFilter = filter);
  }

  void toggleTrope(String trope) {
    setState(() {
      if (!selectedTropes.remove(trope)) selectedTropes.add(trope);
    });
  }

  void clearFilters() {
    _searchController.clear();
    setState(() {
      selectedFilter = "All";
      query = '';
      selectedTropes.clear();
    });
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        key: const Key('search-field'),
        controller: _searchController,
        onChanged: (v) => setState(() => query = v.trim()),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search title',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: AppTheme.cardColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _resultCount(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        '$count ${count == 1 ? 'drama' : 'dramas'}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _emptyState() {
    if (hasActiveFilters) {
      return EmptyState(
        key: const Key('empty-state'),
        icon: Icons.search_off,
        title: 'No dramas found',
        message: 'Nothing matches your current search or filters.',
        actionLabel: 'Clear filters',
        onAction: clearFilters,
      );
    }
    return EmptyState(
      key: const Key('empty-state'),
      icon: Icons.movie_filter_outlined,
      title: 'Your watchlist is empty',
      message: 'There is nothing to filter yet.',
      actionLabel: 'Back to home',
      onAction: () => Navigator.of(context).maybePop(),
    );
  }

  List<Widget> _controls(List<Drama> dramas, {required bool wide}) => [
        StatsCard(dramas: dramas),
        _searchField(),
        const SizedBox(height: 8),
        FilterTabs(selected: selectedFilter, onChanged: updateFilter),
        const SizedBox(height: 8),
        TropeFilter(
          tropes: allTropes,
          selected: selectedTropes,
          onToggle: toggleTrope,
          wrap: wide,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final dramas = filteredDramas;

    return Scaffold(
      appBar: AppBar(title: const Text('Search & filter')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= kTabletBreakpoint;

            final grid = DramaList(
              dramas: dramas,
              emptyState: _emptyState(),
              onTap: (d) => DetailScreen.open(context, d),
            );

            if (wide) {
              final panelWidth =
                  (constraints.maxWidth * 0.4).clamp(280.0, 340.0);

              return Row(
                key: const Key('filter-tablet-layout'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: panelWidth,
                    child: ListView(
                      children: _controls(dramas, wide: true),
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(child: _resultCount(dramas.length)),
                        grid,
                      ],
                    ),
                  ),
                ],
              );
            }

            return CustomScrollView(
              key: const Key('filter-phone-layout'),
              slivers: [
                for (final w in _controls(dramas, wide: false))
                  SliverToBoxAdapter(child: w),
                SliverToBoxAdapter(child: _resultCount(dramas.length)),
                grid,
              ],
            );
          },
        ),
      ),
    );
  }
}