// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/movie_detail_screen.dart';
import '../services/movie_service.dart';
import '../widgets/mainScaffold.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService _movieService = MovieService();
  List<Movie> _movies = [];
  String _currentCategory = 'Popular';
  bool _isLoading = true;

  final Map<String, String> _categories = {
    'Popular': '',
    'Top Rated': '',
    'Action': '28',
    'Drama': '18',
    'Animation': '16',
  };

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() => _isLoading = true);
    try {
      List<Movie> fetchedMovies;
      final genreId = _categories[_currentCategory];

      if (_currentCategory == 'Popular') {
        fetchedMovies = await _movieService.fetchPopularMovies();
      } else if (_currentCategory == 'Top Rated') {
        fetchedMovies = await _movieService.fetchTopRatedMovies();
      } else if (genreId != null && genreId.isNotEmpty) {
        fetchedMovies = await _movieService.fetchMoviesByGenre(genreId);
      } else {
        fetchedMovies = [];
      }

      setState(() {
        _movies = fetchedMovies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Erreur de chargement
    }
  }

  void _onCategorySelected(String category) {
    if (_currentCategory == category) return;
    setState(() => _currentCategory = category);
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: _currentCategory,
      onCategorySelected: _onCategorySelected,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _movies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final movie = _movies[index];
                return MovieCard(
                  movie: movie,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailScreen(movie: movie),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
