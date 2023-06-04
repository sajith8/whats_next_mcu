import 'package:flutter/material.dart';

import 'movie_result.dart';
import 'movie_service.dart';

class MovieProvider extends ChangeNotifier {
  final MovieService _movieService = MovieService();

  Result fetchState = const Loading();

  Future<void> init() async {
    fetchState = await _movieService.init();
    notifyListeners();
  }

  Future<void> refresh() async {
    fetchState = const Loading();
    notifyListeners();
    fetchState = await _movieService.refresh();
    notifyListeners();
  }
}
