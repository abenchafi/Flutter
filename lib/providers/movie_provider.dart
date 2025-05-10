import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import 'package:logging/logging.dart';

class MovieProvider extends ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  List<Movie> _myList = [];
  List<Movie> get myList => _myList;

  final MovieService _movieService = MovieService();
  final Logger _logger = Logger('MovieProvider');

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  MovieProvider() {
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _movies = await _movieService.fetchPopularMovies();
      _logger.info('Fetched ${_movies.length} popular movies');
      
      await loadMyList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _logger.severe('Error fetching movies: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void addToMyList(Movie movie) {
    if (!isInMyList(movie)) {
      _myList.add(movie);
      _logger.info('Added movie to My List: ${movie.title}');
      saveMyList();
      notifyListeners();
    }
  }

  void removeFromMyList(Movie movie) {
    _myList.removeWhere((m) => m.id == movie.id);
    _logger.info('Removed movie from My List: ${movie.title}');
    saveMyList();
    notifyListeners();
  }

  bool isInMyList(Movie movie) {
    return _myList.any((m) => m.id == movie.id);
  }

  Future<void> saveMyList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> movieIds = _myList.map((movie) => movie.id.toString()).toList();
      await prefs.setStringList('my_list', movieIds);
      _logger.info('Saved ${movieIds.length} movies to My List');
    } catch (e) {
      _logger.severe('Error saving My List: $e');
    }
  }

  void clearMyList() {
    _myList.clear();
    _logger.info('Cleared My List');
    saveMyList();
    notifyListeners();
  }


  Future<void> loadMyList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? movieIds = prefs.getStringList('my_list');
      
      if (movieIds != null && movieIds.isNotEmpty) {
        List<int> ids = movieIds.map((id) => int.parse(id)).toList();
        _logger.info('Loading ${ids.length} movies from My List');
        
        List<Movie> tempList = [];

        for (final id in ids) {
          Movie? foundMovie;

          for (var movie in _movies) {
            if (movie.id == id) {
              foundMovie = movie;
              break;
            }
          }
          
          if (foundMovie != null) {
            tempList.add(foundMovie);
          } else {
            _logger.fine('Movie with id $id not found in current movies list, fetching from API');
            try {
              final movie = await _movieService.fetchMovieById(id);
              if (movie != null) {
                tempList.add(movie);
              }
            } catch (e) {
              _logger.warning('Failed to fetch movie with ID $id: $e');
            }
          }
        }
        
        _myList = tempList;
        notifyListeners();
      } else {
        _logger.info('No saved movies found in My List');
      }
    } catch (e) {
      _logger.severe('Error loading My List: $e');
    }
  }
}