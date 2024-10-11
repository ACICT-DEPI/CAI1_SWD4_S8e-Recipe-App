import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dio_helper.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  // دالة لجلب الوصفات المفضلة من Firebase
  Future<void> fetchFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // جلب البيانات من Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(user.uid)
          .collection('recipes')
          .get();

      List<Map<String, dynamic>> favorites = [];

      for (var doc in snapshot.docs) {
        var recipeData = doc.data() as Map<String, dynamic>;

        // جلب تفاصيل الوصفة من API باستخدام DioHelper
        var response = await DioHelper.getRecipeById(recipeData['recipeId']);

        if (response != null && response.statusCode == 200 && response.data['meals'] != null) {
          favorites.add(response.data['meals'][0]);
        } else {
          print('Error: Failed to fetch meal data for ID ${recipeData['recipeId']}');
        }
      }

      setState(() {
        favoriteRecipes = favorites;
      });
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: const Color(0xFFf96163),
      ),
      body: favoriteRecipes.isEmpty
          ? const Center(child: CircularProgressIndicator()) // إظهار تحميل إذا كانت القائمة فارغة
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                var recipe = favoriteRecipes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  child: ListTile(
                    leading: Image.network(
                      recipe['strMealThumb'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(recipe['strMeal']),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        // يمكنك إضافة دالة لإزالة العنصر من المفضلة
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
