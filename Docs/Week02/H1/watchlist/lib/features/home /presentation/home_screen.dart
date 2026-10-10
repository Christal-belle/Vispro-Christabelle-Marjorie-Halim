import 'package:flutter/material.dart';
import 'package:watchlist/core/data/drama_data.dart';
import 'package:watchlist/features/home /widgets/drama_list.dart';
import 'package:watchlist/features/home /widgets/header_bar.dart';
import 'package:watchlist/core/models/drama.dart';
import 'package:watchlist/features/home /widgets/stats_card.dart';
import 'package:watchlist/core/layout/breakpoints.dart';
import 'package:watchlist/features/home /presentation/detail_screen.dart';
import 'package:watchlist/features/home /presentation/filter_screen.dart';
import 'package:watchlist/features/home /widgets/empty_state.dart';

class HomeScreen extends StatelessWidget {
  final List<Drama>? dramas;
  const HomeScreen({super.key, this.dramas});

  Widget _filterButton(BuildContext context, List<Drama> list) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.tonalIcon(
          key: const Key('open-filter'),
          onPressed: () => FilterScreen.open(context, list),
          icon: const Icon(Icons.tune),
          label: const Text('Search & filter'),
        ),
      ),
    );
  }
 
  Widget _sectionTitle(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        'All dramas · $count',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
 
  Widget _emptyState(BuildContext context) {
    return EmptyState(
      key: const Key('empty-state'),
      icon: Icons.movie_filter_outlined,
      title: 'Your watchlist is empty',
      message: 'Add your first drama to start tracking it.',
      actionLabel: 'Add drama',
      onAction: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add form coming soon')),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final list = dramas ?? kDramas;
 
    return Scaffold(
      appBar: const HeaderBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= kTabletBreakpoint;
 
            final grid = DramaList(
              dramas: list,
              emptyState: _emptyState(context),
              onTap: (d) => DetailScreen.open(context, d),
            );
 
            if (wide) {
              final panelWidth =
                  (constraints.maxWidth * 0.4).clamp(280.0, 340.0);
 
              return Row(
                key: const Key('tablet-layout'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: panelWidth,
                    child: ListView(
                      children: [
                        StatsCard(dramas: list),
                        _filterButton(context, list),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        if (list.isNotEmpty)
                          SliverToBoxAdapter(
                              child: _sectionTitle(context, list.length)),
                        grid,
                      ],
                    ),
                  ),
                ],
              );
            }
 
            return CustomScrollView(
              key: const Key('phone-layout'),
              slivers: [
                SliverToBoxAdapter(child: StatsCard(dramas: list)),
                SliverToBoxAdapter(child: _filterButton(context, list)),
                if (list.isNotEmpty)
                  SliverToBoxAdapter(
                      child: _sectionTitle(context, list.length)),
                grid,
              ],
            );
          },
        ),
      ),
    );
  }
}
 