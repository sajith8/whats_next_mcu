import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../model/movie.dart';

class MoviePoster extends StatelessWidget {
  const MoviePoster({
    super.key,
    required this.movie,
  });

  final (Uint8List, Movie) movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Stack(
        children: [
          Image.memory(
            movie.$1,
            scale: 1.6,
            fit: BoxFit.fitWidth,
          ),
          Positioned(
            bottom: 4,
            right: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                shape: BoxShape.rectangle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.timer,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 30,
                    ),
                    Text(
                      movie.$2.noDays.inDays.toString(),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                    Text(
                      " days left",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
