import 'package:flutter/material.dart';
import 'package:flutter_movies_app/providers/movie_provider.dart';
import 'package:flutter_movies_app/screens/movie_detail_screen.dart';
import 'package:flutter_movies_app/widgets/movie_card.dart';
import 'package:provider/provider.dart';

class MyListScreen extends StatelessWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My List'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              provider.clearMyList(); // Appeler la méthode pour vider la liste
            },
          ),
        ],
      ),
      body: provider.myList.isEmpty
          ? Center(
              child: Text('No movies in your list'),
            )
          : GridView.builder(
              itemCount: provider.myList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final movie = provider.myList[index];
                return MovieCard(
                  movie: movie,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)),
                    );
                  },
                );
              },
            ),
    );
  }
}
