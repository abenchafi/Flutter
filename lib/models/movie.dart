class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled',
      overview: json['overview'] ?? 'No description available',
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      releaseDate: json['release_date'] ?? 'Unknown',
    );
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Movie && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}