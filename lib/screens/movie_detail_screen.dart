import 'package:flutter/material.dart';
import 'package:flutter_movies_app/screens/actor_movie_screen.dart';
import '../models/movie.dart';
import '../models/actor.dart';
import '../services/movie_service.dart';
import '../providers/movie_provider.dart';
import 'package:provider/provider.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final MovieService _movieService = MovieService();
  List<Actor> _actors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovieCredits();
  }

  Future<void> _loadMovieCredits() async {
    try {
      final credits = await _movieService.getMovieCredits(widget.movie.id);
      setState(() {
        _actors = credits;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors du chargement des acteurs')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final posterUrl = widget.movie.posterPath != null
        ? 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}'
        : null;

    // Accès au provider pour la gestion de "Ma liste"
    final movieProvider = Provider.of<MovieProvider>(context);
    final isInMyList = movieProvider.isInMyList(widget.movie);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            icon: Icon(
              isInMyList ? Icons.favorite : Icons.favorite_border,
              color: isInMyList ? Colors.red : null,
            ),
            onPressed: () {
              if (isInMyList) {
                movieProvider.removeFromMyList(widget.movie);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${widget.movie.title} retiré de votre liste')),
                );
              } else {
                movieProvider.addToMyList(widget.movie);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${widget.movie.title} ajouté à votre liste')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (posterUrl != null)
              Center(
                child: Image.network(
                  posterUrl,
                  height: 400,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                    );
                  },
                ),
              )
            else
              const Center(
                child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
              ),
            const SizedBox(height: 16),
            Text(
              widget.movie.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.movie.overview,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Acteurs principaux',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_actors.isEmpty)
              const Text("Aucun acteur trouvé.")
            else
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _actors.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final actor = _actors[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigation vers la liste des films de l'acteur
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ActorMovieScreen(
                              actorId: actor.id,
                              actorName: actor.name,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          ClipOval(
                            child: Image.network(
                              actor.profilePath.isNotEmpty
                                  ? 'https://image.tmdb.org/t/p/w200${actor.profilePath}'
                                  : 'https://via.placeholder.com/100',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person, size: 100, color: Colors.grey);
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 100,
                            child: Text(
                              actor.name,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}