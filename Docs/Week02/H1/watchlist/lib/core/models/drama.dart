class Drama {
  final String title;
  final String status;
  final String? imagePath;
  final int? year;
  final int episodes;
  final String genre;
  final int watchedEpisodes;
  final double? rating;
  final List<String> tropes;
  final int episodeDuration; 
  final String synopsis;

  Drama({
    required this.title,
    required this.status,
    required this.episodes,
    this.imagePath,
    this.year,
    this.watchedEpisodes = 0,
    this.rating,
    this.tropes = const [],
    this.episodeDuration = 60,
    this.genre = '',
    required this.synopsis,
  });

  int get unwatchedEpisodes => episodes - watchedEpisodes;
  double get progress => episodes == 0 ? 0 : watchedEpisodes / episodes;
  int get watchedMinutes => watchedEpisodes * episodeDuration;
}

String formatDuration(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '${m}m';
  return '${h}h ${m}m';
}