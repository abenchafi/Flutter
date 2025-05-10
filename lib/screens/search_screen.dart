import 'package:flutter/material.dart';
import 'package:flutter_movies_app/models/movie.dart';
import 'package:flutter_movies_app/services/movie_service.dart';
import 'package:flutter_movies_app/screens/movie_detail_screen.dart';
import 'package:flutter_movies_app/widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> { 
  final TextEditingController _controller = TextEditingController();
  final MovieService _movieService = MovieService();
  List<Movie> _searchResults = [];
  bool _isLoading = false;

  void _searchMovies(String query) async {
    setState(() {
      _isLoading = true;
    });

    final results = await _movieService.searchMovies(query);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchMovies(_controller.text),
                ),
              ),
              onSubmitted: (query) => _searchMovies(query),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    itemCount: _searchResults.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final movie = _searchResults[index];
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
          ),
        ],
      ),
    );
  }
}
