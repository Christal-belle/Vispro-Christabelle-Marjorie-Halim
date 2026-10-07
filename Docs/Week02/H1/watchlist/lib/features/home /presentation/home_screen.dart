import 'package:flutter/material.dart';
import 'package:watchlist/features/home /widgets/drama_list.dart';
import 'package:watchlist/features/home /widgets/filter_tabs.dart';
import 'package:watchlist/features/home /widgets/header_bar.dart';
import 'package:watchlist/core/models/drama.dart';
import 'package:watchlist/features/home /widgets/trope_filter.dart';
import 'package:watchlist/features/home /widgets/stats_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "All";
  final Set<String> selectedTropes = {};

  final List<Drama> allDramas = [
    Drama(
      title: "Lovely Runner",
      status: "Completed",
      year: 2024,
      episodes: 16,
      watchedEpisodes: 16,
      rating: 10,
      episodeDuration: 70,
      genre: "Romance",
      tropes: ["Time Travel", "Idol & Fan"],
      imagePath: "https://1.vikiplatform.com/c/40466c/dbbd0e5018.jpg?x=b",
      ),

    Drama(
      title: "Wonderfools",
      status: "Watching",
      year: 2026,
      episodes: 8,
      watchedEpisodes: 4,
      rating: 8,
      episodeDuration: 55,
      genre: "Fantasy",
      tropes: ["Superpower", "Found Family"],
      imagePath: "https://awsimages.detik.net.id/community/media/visual/2026/04/17/the-wonderfools-1776411449782.jpeg?w=700&q=90",
    ),

    Drama(
      title: "Business Proposal",
      status: "Plan",
      year: 2022,
      episodes: 12,
      episodeDuration: 65,
      genre: "Romance",
      tropes: ["CEO Male Lead", "Fake Dating", "Mistaken Identity"],
      imagePath: "https://upload.wikimedia.org/wikipedia/en/1/19/A_Business_Proposal.jpg?utm_source=en.wikipedia.org&utm_campaign=index&utm_content=original",
      ),
  ];

  List<String> get allTropes {
    final set = <String>{for (final d in allDramas) ...d.tropes};
    return set.toList()..sort();
  }
  
  List<Drama> get filteredDramas {
    return allDramas.where((d) {
      final statusOk = selectedFilter == "All" || d.status == selectedFilter;
      final tropeOk =
          selectedTropes.isEmpty || selectedTropes.every(d.tropes.contains);
      return statusOk && tropeOk;
    }).toList();
  }

  void updateFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  void toggleTrope(String trope) {
    setState(() {
      if (!selectedTropes.remove(trope)) selectedTropes.add(trope);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dramas = filteredDramas;

    return Scaffold(
      appBar: const HeaderBar(),
      body: Column(
        children: [
          StatsCard(dramas: dramas),
          const SizedBox(height: 8),
          FilterTabs(
            selected: selectedFilter,
            onChanged: updateFilter,
          ),
          const SizedBox(height: 4),
          TropeFilter(
            tropes: allTropes,
            selected: selectedTropes,
            onToggle: toggleTrope,
          ),
          Expanded(
            child: DramaList(dramas: filteredDramas),
          ),
        ],
      ),
    );
  }
}