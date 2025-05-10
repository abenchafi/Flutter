import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const MovieCard({
    required this.movie,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hasPoster = movie.posterPath != null && movie.posterPath!.isNotEmpty;
    final imageUrl = hasPoster
        ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageUrl != null)
              Expanded(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                movie.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
