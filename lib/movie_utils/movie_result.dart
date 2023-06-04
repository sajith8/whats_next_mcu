import 'dart:typed_data';

import '../model/movie.dart';

sealed class Result {
  const Result();
}

final class Success implements Result {
  const Success({
    required this.movie,
    required this.upcomingMovie,
  });

  final (Uint8List, Movie) movie;
  final (Uint8List, Movie) upcomingMovie;
}

final class Failed implements Result {
  const Failed([this.message = "Something Went Wrong"]);

  final String message;
}

final class Loading implements Result {
  const Loading();
}
