import 'package:flutter/material.dart';
import 'package:flutter_movies_app/providers/movie_provider.dart';
import 'package:flutter_movies_app/screens/home_screen.dart';
import 'package:flutter_movies_app/screens/my_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NexiFlix',
        theme: ThemeData.dark(),
        home: HomeScreen(),
        routes: {
          '/mylist': (context) => const MyListScreen(),
        },
      ),
    );
  }
}
