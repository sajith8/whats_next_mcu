import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'movie_utils/movie_provider.dart';
import 'ui/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexThemeData.light(scheme: FlexScheme.espresso),
      home: ChangeNotifierProvider(
        create: (BuildContext context) => MovieProvider(),
        child: const Home(),
      ),
    );
  }
}
