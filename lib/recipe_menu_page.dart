import 'package:cooksy/profile_page.dart';
import 'package:cooksy/search_page.dart';
import 'package:cooksy/user_add_recipe.dart';
import 'package:flutter/material.dart';
import 'package:cooksy/recipe_view_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_helper.dart';
import 'favorites_page.dart';

class RecipeMenu extends StatefulWidget {
  const RecipeMenu({super.key});

  @override
  State<RecipeMenu> createState() => _MenuViewState();
}

class _MenuViewState extends State<RecipeMenu> {
  List<String> categories = [];
  List<Map<String, String>> meals = [];
  int _selectedIndex = 0;
  Set<String> favoriteMeals = {};
  Map<String, double> mealRatings = {};
  bool isLoading = true;

  final List<Widget> _pages = [
    const RecipeMenu(), // Replace with the actual page for recipes
    const SearchPage(),
    UserAdd(onRecipeAdded: (Recipe) { /* handle added recipe */ }),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    loadFavorites();
  }

  // Fetch categories from the API
  void fetchCategories() async {
    // Your fetching logic here
  }

  // Load favorite meals from SharedPreferences
  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteMeals = prefs.getStringList('favorites')?.toSet() ?? {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: const Color(0xfffee3625),
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: const Color(0xfffee3625).withOpacity(0.1),
            color: Colors.grey[800],
            tabs: const [
              GButton(
                icon: Icons.restaurant_menu,
                text: 'Recipes',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.add,
                text: 'Add Recipe',
              ),
              GButton(
                icon: Icons.favorite,
                text: 'Favorites',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
