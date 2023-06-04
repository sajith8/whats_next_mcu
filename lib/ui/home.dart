import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/movie.dart';
import '../movie_utils/movie_provider.dart';
import '../movie_utils/movie_result.dart';
import '../movie_widget/movie_poster.dart';
import 'error.dart';
import 'loading.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Provider.of<MovieProvider>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    final Result result = context.watch<MovieProvider>().fetchState;
    return switch (result) {
      Success(movie: final movie, upcomingMovie: final upcomingMovie) => HomeScreen(
          movie: movie,
          upcomingMovie: upcomingMovie,
        ),
      Failed(message: final message) => ErrorScreen(message: message),
      Loading() => const LoadingScreen(),
    };
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required this.movie,
    required this.upcomingMovie,
  }) : super(key: key);

  final (Uint8List, Movie) movie;
  final (Uint8List, Movie) upcomingMovie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Row(
          children: [
            Text(
              "What's Next",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.read<MovieProvider>().refresh(),
            icon: const Icon(
              Icons.refresh,
              size: 30,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Column(
        children: [
          MoviePoster(movie: movie),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    movie.$2.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 300,
                            child: ListView(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      movie.$2.type,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    Text(
                                      DateFormat("EEE, MMM d, yyyy").format(movie.$2.releaseDate),
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                                const Divider(thickness: 3),
                                RichText(
                                  textAlign: TextAlign.justify,
                                  text: TextSpan(
                                    children: [
                                      const WidgetSpan(child: SizedBox(width: 60)),
                                      TextSpan(
                                        text: movie.$2.overview,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Coming soon..",
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Coming soon..",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        MoviePoster(movie: upcomingMovie),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.read_more_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
