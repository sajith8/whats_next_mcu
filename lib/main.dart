import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'my_app.dart';

void main() async {
  await _initHive();
  runApp(const MyApp());
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  await Hive.openBox("movies");
}
