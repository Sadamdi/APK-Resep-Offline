import 'package:flutter/material.dart';

import 'detail_page.dart';
import 'recipe_data.dart'; // Import data resep dari file terpisah

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, String>> filteredRecipes = [];
  String searchQuery = '';

  // Track the favorite status for each recipe
  List<bool> favoriteStatus = [];

  @override
  void initState() {
    super.initState();
    filteredRecipes = recipes;
    favoriteStatus = List<bool>.filled(
        recipes.length, false); // Initialize all as not favorite
  }

  void _filterRecipes(String query) {
    setState(() {
      searchQuery = query;
      if (searchQuery.isEmpty) {
        filteredRecipes = recipes;
      } else {
        filteredRecipes = recipes
            .where((recipe) => recipe['title']!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      favoriteStatus[index] = !favoriteStatus[index]; // Toggle favorite status
    });
  }

  void _navigateToDetail(BuildContext context, Map<String, String> recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RecipeDetailPage(
                imageUrl: recipe['imageUrl']!,
                title: recipe['title']!,
                ingredients: recipe['ingredients']!,
                instructions: recipe['instructions']!,
                calories: recipe['calories']!,
                time: recipe['time']!,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipes'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is in your kitchen?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: _filterRecipes,
              decoration: InputDecoration(
                hintText: 'Find your perfect recipe here!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            // Menggunakan Expanded agar grid bisa diskroll
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: (150 / 230),
                children: [
                  for (int index = 0; index < filteredRecipes.length; index++)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 0.5,
                              blurRadius: 2)
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Image clickable
                          InkWell(
                            onTap: () {
                              _navigateToDetail(
                                  context, filteredRecipes[index]);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    filteredRecipes[index]['imageUrl']!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title clickable
                                  InkWell(
                                    onTap: () {
                                      _navigateToDetail(
                                          context, filteredRecipes[index]);
                                    },
                                    child: Text(
                                      filteredRecipes[index]['title']!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  // Best Recipe clickable
                                  InkWell(
                                    onTap: () {
                                      _navigateToDetail(
                                          context, filteredRecipes[index]);
                                    },
                                    child: const Text(
                                      "Best Recipe",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  filteredRecipes[index]['calories']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  filteredRecipes[index]['time']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                                // Favorite icon with toggle functionality
                                InkWell(
                                  onTap: () {
                                    _toggleFavorite(index);
                                  },
                                  child: Icon(
                                    favoriteStatus[index]
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    color: favoriteStatus[index]
                                        ? Colors.red
                                        : Colors.black,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
