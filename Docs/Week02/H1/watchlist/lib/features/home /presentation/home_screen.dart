import 'package:flutter/material.dart';
import 'package:watchlist/features/home /widgets/drama_list.dart';
import 'package:watchlist/features/home /widgets/filter_tabs.dart';
import 'package:watchlist/features/home /widgets/header_bar.dart';
import 'package:watchlist/core/models/drama.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "All";

  final List<Drama> allDramas = [
    Drama(title: "Lovely Runner", status: "Completed"),
    Drama(title: "Wonderfools", status: "Watching"),
    Drama(title: "Business Proposal", status: "Plan"),
  ];

  List<Drama> get filteredDramas {
    if (selectedFilter == "All") return allDramas;
    return allDramas
        .where((d) => d.status == selectedFilter)
        .toList();
  }

  void updateFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(),
      body: Column(
        children: [
          FilterTabs(
            selected: selectedFilter,
            onChanged: updateFilter,
          ),
          Expanded(
            child: DramaList(dramas: filteredDramas),
          ),
        ],
      ),
    );
  }
}