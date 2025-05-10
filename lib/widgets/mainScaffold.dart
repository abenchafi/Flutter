import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Function(String) onCategorySelected;

  const MainScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.onCategorySelected,
  });

  // Alignement avec les catégories dans home_screen.dart
  static final List<String> _categories = [
    'Popular',
    'Top Rated',
    'Action',
    'Drama',
    'Animation',  // Changé de 'Anime' à 'Animation' pour correspondre à home_screen.dart
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Text(
                'Movie Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ..._categories.map((category) => ListTile(
              title: Text(category),
              onTap: () {
                Navigator.pop(context);
                onCategorySelected(category);
              },
              selected: title == category,  // Comparaison exacte du titre
              selectedTileColor: Colors.grey.shade300,
            )),
          ],
        ),
      ),
      body: body,
    );
  }
}