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

  // État de chargement
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  MovieProvider() {
    fetchMovies();
  }

  // Charger les films populaires depuis MovieService
  Future<void> fetchMovies() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _movies = await _movieService.fetchPopularMovies();
      _logger.info('Fetched ${_movies.length} popular movies');
      
      // Une fois les films récupérés, nous chargeons "Ma liste"
      await loadMyList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _logger.severe('Error fetching movies: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ajouter un film à la liste "Ma liste"
  void addToMyList(Movie movie) {
    if (!isInMyList(movie)) {
      _myList.add(movie);
      _logger.info('Added movie to My List: ${movie.title}');
      saveMyList();
      notifyListeners();
    }
  }

  // Supprimer un film de "Ma liste"
  void removeFromMyList(Movie movie) {
    _myList.removeWhere((m) => m.id == movie.id);
    _logger.info('Removed movie from My List: ${movie.title}');
    saveMyList();
    notifyListeners();
  }

  // Vérifier si un film est dans "Ma liste"
  bool isInMyList(Movie movie) {
    return _myList.any((m) => m.id == movie.id);
  }

  // Sauvegarder "Ma liste" dans SharedPreferences
  Future<void> saveMyList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Nous stockons une liste d'IDs de films dans SharedPreferences
      List<String> movieIds = _myList.map((movie) => movie.id.toString()).toList();
      await prefs.setStringList('my_list', movieIds);
      _logger.info('Saved ${movieIds.length} movies to My List');
    } catch (e) {
      _logger.severe('Error saving My List: $e');
    }
  }

  // Vider "Ma liste"
  void clearMyList() {
    _myList.clear();
    _logger.info('Cleared My List');
    saveMyList();
    notifyListeners();
  }

  // Charger "Ma liste" depuis SharedPreferences
  Future<void> loadMyList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? movieIds = prefs.getStringList('my_list');
      
      if (movieIds != null && movieIds.isNotEmpty) {
        // Convertir les IDs en entiers
        List<int> ids = movieIds.map((id) => int.parse(id)).toList();
        _logger.info('Loading ${ids.length} movies from My List');
        
        // Liste temporaire pour éviter les notifications intermédiaires
        List<Movie> tempList = [];
        
        // D'abord, rechercher les films correspondants dans notre liste de films déjà chargés
        for (final id in ids) {
          // Chercher le film dans les films déjà chargés
          Movie? foundMovie;
          
          // Recherche dans la liste actuelle
          for (var movie in _movies) {
            if (movie.id == id) {
              foundMovie = movie;
              break;
            }
          }
          
          if (foundMovie != null) {
            tempList.add(foundMovie);
          } else {
            // Film non trouvé dans la liste actuelle, on essaie de le récupérer depuis l'API
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