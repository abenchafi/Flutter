import 'package:flutter/material.dart';
import 'package:flutter_movies_app/models/movie.dart';
import 'package:flutter_movies_app/services/movie_service.dart';
import 'package:flutter_movies_app/widgets/movie_card.dart';
import 'package:flutter_movies_app/screens/movie_detail_screen.dart';
import 'package:logging/logging.dart';

class ActorMovieScreen extends StatefulWidget {
  final int actorId;
  final String actorName;

  const ActorMovieScreen({super.key, required this.actorId, required this.actorName});

  @override
  ActorMovieScreenState createState() => ActorMovieScreenState();
}

class ActorMovieScreenState extends State<ActorMovieScreen> {
  final MovieService _movieService = MovieService();
  final Logger _logger = Logger('ActorMovieScreen');
  List<Movie> _actorMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActorMovies();
  }

  // Méthode pour charger les films de l'acteur
  void _loadActorMovies() async {
    try {
      _logger.info('Fetching movies for actorId: ${widget.actorId}');
      final movies = await _movieService.getPopularMoviesByActor(widget.actorId);
      if (movies.isEmpty) {
        _logger.warning('No movies found for actor: ${widget.actorName}');
      }
      setState(() {
        _actorMovies = movies;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _logger.severe('Error fetching actor movies: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des films')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.actorName}\'s Movies'), // Titre dynamique avec le nom de l'acteur
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Simplement revenir en arrière
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _actorMovies.isEmpty
              ? const Center(child: Text('No movies found for this actor.'))
              : GridView.builder(
                  itemCount: _actorMovies.length,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final movie = _actorMovies[index];
                    return MovieCard(
                      movie: movie,
                      onTap: () {
                        // Naviguer vers le détail du film
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