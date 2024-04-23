import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/core/recipe.dart';

class RecipeHelper {
  static const String _bookmarkKey = 'bookmarked_recipes';

  // Method to save a recipe to SharedPreferences as a bookmark
  static Future<void> saveBookmark(Recipe recipe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve existing bookmarks
    List<String>? bookmarkedRecipes = prefs.getStringList(_bookmarkKey);

    // If there are no existing bookmarks, create a new list
    bookmarkedRecipes ??= [];

    // Convert Recipe object to JSON
    String recipeJson = jsonEncode(recipe.toJson());

    // Add the current recipe to the list of bookmarks
    bookmarkedRecipes.add(recipeJson);

    await prefs.setStringList(_bookmarkKey, bookmarkedRecipes);
  }

  // Method to fetch bookmarked recipes from SharedPreferences
  static Future<List<Recipe>> getBookmarkedRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve bookmarked recipes from SharedPreferences
    List<String>? bookmarkedRecipes = prefs.getStringList(_bookmarkKey);

    // If no bookmarks found, return an empty list
    if (bookmarkedRecipes == null) {
      return [];
    }

    // Convert JSON strings back to Recipe objects
    List<Recipe> recipes = bookmarkedRecipes.map((jsonString) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return Recipe.fromJson(json);
    }).toList();

    return recipes;
  }
}
