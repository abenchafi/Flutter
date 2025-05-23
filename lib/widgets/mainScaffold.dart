import 'package:flutter/material.dart';
import 'package:flutter_movies_app/screens/search_screen.dart';

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

  static final List<String> _categories = [
    'Popular',
    'Top Rated',
    'Action',
    'Drama',
    'Animation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
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
            ListTile(
              title: const Text('Ma liste'),
              leading: const Icon(Icons.favorite),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/mylist');
              },
            ),
            ..._categories.map(
              (category) => ListTile(
                title: Text(category),
                onTap: () {
                  Navigator.pop(context);
                  onCategorySelected(category);
                },
                selected: title == category,
                selectedTileColor: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
