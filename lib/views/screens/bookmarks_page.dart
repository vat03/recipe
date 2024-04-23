import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hungry_app/models/core/recipe.dart';
import 'package:hungry_app/models/helper/recipe_helper.dart';
import 'package:hungry_app/views/utils/AppColor.dart';
import 'package:hungry_app/views/widgets/featured_recipe_card.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  TextEditingController searchInputController = TextEditingController();
  List<Recipe> bookmarkedRecipes = [];

  @override
  void initState() {
    super.initState();
    // Fetch bookmarked recipes when the page initializes
    fetchBookmarkedRecipes();
  }

  // Method to fetch bookmarked recipes from SharedPreferences
  Future<void> fetchBookmarkedRecipes() async {
    List<Recipe> recipes = await RecipeHelper.getBookmarkedRecipes();
    setState(() {
      bookmarkedRecipes = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        centerTitle: false,
        title: const Text(
          "Bookmarks",
        ),
        elevation: 0,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Search Bar
          bookmarkedRecipes.isEmpty
              ? const Center(
                  child: Text(
                    'No bookmarked recipes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: bookmarkedRecipes.length,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
                    },
                    itemBuilder: (context, index) {
                      return FeaturedRecipeCard(
                        data: bookmarkedRecipes[index],
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
