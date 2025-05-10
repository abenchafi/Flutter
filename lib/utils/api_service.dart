import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/movie.dart';
import '../../utils/constants.dart';
import '../models/actor.dart';

class MovieService {
  // Récupérer les crédits d'un film (acteurs)
  Future<List<Actor>> getMovieCredits(int movieId) async {
    final response = await http.get(
      Uri.parse(
        "${Constants.baseUrl}/movie/$movieId/credits?api_key=${Constants.apiKey}",
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['cast'];
      return (data as List).map((json) => Actor.fromJson(json)).toList();
    } else {
      throw Exception("Erreur lors de la récupération des crédits.");
    }
  }
}

class ApiService {
  // Récupérer les films populaires
  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse(
        "${Constants.baseUrl}/movie/popular?api_key=${Constants.apiKey}",
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception("Erreur de chargement des films");
    }
  }

  // Nouvelle méthode pour récupérer les films par catégorie
  Future<List<Movie>> getMoviesByCategory(String category) async {
    final response = await http.get(
      Uri.parse(
        "${Constants.baseUrl}/discover/movie?api_key=${Constants.apiKey}&with_genres=$category",
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception("Erreur de chargement des films de catégorie $category");
    }
  }

  // Optionnel : Ajout d'une méthode pour obtenir les films les mieux notés
  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(
      Uri.parse(
        "${Constants.baseUrl}/movie/top_rated?api_key=${Constants.apiKey}",
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception("Erreur de chargement des films top-rated");
    }
  }
}
