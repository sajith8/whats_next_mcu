final class Movie {
  const Movie({
    required this.title,
    required this.type,
    required this.overview,
    required this.poster,
    required this.noDays,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"],
      type: json["type"],
      overview: json["overview"],
      poster: json["poster_url"],
      noDays: Duration(days: json["days_until"]),
      releaseDate: DateTime.parse(json["release_date"]),
    );
  }

  final String title;
  final String type;
  final String overview;
  final String poster;
  final Duration noDays;
  final DateTime releaseDate;

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "type": type,
      "overview": overview,
      "poster_url": poster,
      "days_until": noDays.inDays,
      "release_date": releaseDate.toIso8601String(),
    };
  }
}

(Movie, Movie) getMoviesFromJson(Map<String, dynamic> json) {
  return (
    Movie.fromJson(json),
    Movie.fromJson(json["following_production"]),
  );
}
