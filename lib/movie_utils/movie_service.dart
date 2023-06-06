import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../model/movie.dart';
import 'movie_exception.dart';
import 'movie_result.dart';

class MovieService {
  final Box _box = Hive.box("movies");

  Future<Result> init() async {
    final DateTime? lastUpdated = _box.get("lastUpdated");
    final int timeBetween =
        DateTime.now().difference(lastUpdated ?? DateTime.now()).inHours;

    if (lastUpdated == null || timeBetween > 24) {
      return refresh();
    }

    final Map<String, dynamic> nextMovie = Map.castFrom(_box.get("nextMovie"));
    final Map<String, dynamic> upcomingMovie =
        Map.castFrom(_box.get("upcomingMovie"));

    return Success(
      movie: (_box.get("nextMovieImage"), Movie.fromJson(nextMovie)),
      upcomingMovie: (
        _box.get("upcomingMovieImage"),
        Movie.fromJson(upcomingMovie)
      ),
    );
  }

  Future<Result> refresh() async {
    try {
      final (Movie, Movie) movies = await _getMovies();
      final Uint8List movieImage = await _getMovieImage(movies.$1.poster);
      final Uint8List upComingMovieImage =
          await _getMovieImage(movies.$2.poster);

      _box.put("lastUpdated", DateTime.now());
      _box.put("nextMovie", movies.$1.toMap());
      _box.put("nextMovieImage", movieImage);
      _box.put("upcomingMovie", movies.$2.toMap());
      _box.put("upcomingMovieImage", upComingMovieImage);

      return Success(
        movie: (movieImage, movies.$1),
        upcomingMovie: (upComingMovieImage, movies.$2),
      );
    } catch (e) {
      if (e is MovieException) {
        return Failed(e.message);
      }

      return const Failed();
    }
  }

  Future<(Movie, Movie)> _getMovies() async {
    Uri url = Uri.parse("https://www.whenisthenextmcufilm.com/api");

    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);

        return getMoviesFromJson(json);
      } else {
        throw const MovieFetchException("Please try again later.");
      }
    } on MovieException {
      rethrow;
    } on SocketException {
      throw const MovieConnectivityException("Check Network Connectivity");
    } catch (e) {
      throw const MovieUnknownException("Something went wrong");
    }
  }

  Future<Uint8List> _getMovieImage(String posterUrl) async {
    Uri url = Uri.parse(posterUrl);

    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw const MovieFetchException("Please try again later.");
      }
    } on MovieException {
      rethrow;
    } catch (e) {
      throw const MovieUnknownException("Something went wrong");
    }
  }
}
