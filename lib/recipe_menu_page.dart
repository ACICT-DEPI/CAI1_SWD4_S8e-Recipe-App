import 'package:cooksy/favorites_page.dart';
import 'package:cooksy/profile_page.dart';
import 'package:cooksy/search_page.dart';
import 'package:cooksy/user_add_recipe.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeMenu extends StatefulWidget {
  const RecipeMenu({super.key});

  @override
  State<RecipeMenu> createState() => _MenuViewState();
}

class _MenuViewState extends State<RecipeMenu> {
  List<String> categories = [];
  List<Map<String, String>> meals = [];
  int _selectedIndex = 0;
  Set<String> favoriteMeals = <String>{};
  Map<String, double> mealRatings = {}; // Map to store meal ratings
  bool isLoading = true; // To show loading indicator

  final List<Widget> _pages = [
    // Replace with your actual pages
    RecipeMenu(), // This should probably be replaced with another page
    SearchPage(),
    UserAdd(onRecipeAdded: (recipe) {
      // Handle recipe added
    }),
    FavoritesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
    loadFavorites(); // Load favorites when the app starts
  }

  void fetchCategories() async {
    // Implement your logic to fetch categories from your data source
    // Simulating a delay for fetching data
    await Future.delayed(Duration(seconds: 2), () {
      setState(() {
        categories = ['Breakfast', 'Lunch', 'Dinner']; // Example categories
        isLoading = false; // Set loading to false after fetching
      });
    });
  }

  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Load favorites from SharedPreferences
    // Example: favoriteMeals = prefs.getStringList('favorites')?.toSet() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _pages[_selectedIndex], // Display the selected page

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Recipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Color(0xFFEE3625),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
