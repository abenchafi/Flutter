// lib/services/movie_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../utils/constants.dart';
import 'package:logging/logging.dart';

class MovieService {
  final Logger _logger = Logger('MovieService');

  // Films populaires
  Future<List<Movie>> fetchPopularMovies() async {
    _logger.info('Fetching popular movies');
    final response = await http.get(
      Uri.parse("${Constants.baseUrl}/movie/popular?api_key=${Constants.apiKey}"),
    );
    return _parseMovies(response);
  }

  // Films les mieux notés
  Future<List<Movie>> fetchTopRatedMovies() async {
    _logger.info('Fetching top rated movies');
    final response = await http.get(
      Uri.parse("${Constants.baseUrl}/movie/top_rated?api_key=${Constants.apiKey}"),
    );
    return _parseMovies(response);
  }

  // Films par genre
  Future<List<Movie>> fetchMoviesByGenre(String genreId) async {
    _logger.info('Fetching movies by genre: $genreId');
    final response = await http.get(
      Uri.parse("${Constants.baseUrl}/discover/movie?api_key=${Constants.apiKey}&with_genres=$genreId"),
    );
    return _parseMovies(response);
  }

  // Récupérer un film spécifique par son ID
  Future<Movie?> fetchMovieById(int movieId) async {
    _logger.info('Fetching movie details for ID: $movieId');
    final response = await http.get(
      Uri.parse("${Constants.baseUrl}/movie/$movieId?api_key=${Constants.apiKey}"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      _logger.warning('Failed to fetch movie by ID $movieId: ${response.statusCode}');
      return null;
    }
  }

 

  // Films avec un acteur spécifique
  Future<List<Movie>> getPopularMoviesByActor(int actorId) async {
    _logger.info('Fetching movies for actor: $actorId');
    final response = await http.get(
      Uri.parse("${Constants.baseUrl}/discover/movie?api_key=${Constants.apiKey}&with_cast=$actorId"),
    );
    return _parseMovies(response);
  }

  // Recherche de films
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];
    
    _logger.info('Searching movies with query: $query');
    final response = await http.get(
      Uri.parse("${Constants.baseUrl}/search/movie?api_key=${Constants.apiKey}&query=${Uri.encodeComponent(query)}"),
    );
    return _parseMovies(response);
  }

  // Méthode d'analyse commune
  List<Movie> _parseMovies(http.Response response) {
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      _logger.severe('Error parsing movies: ${response.statusCode}');
      throw Exception("Erreur lors du chargement des films");
    }
  }
}