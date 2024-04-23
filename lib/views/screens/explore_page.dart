import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;

import 'package:hungry_app/models/core/recipe.dart';
import 'package:hungry_app/views/screens/categoryScreen.dart';
import 'package:hungry_app/views/utils/AppColor.dart';
import 'package:hungry_app/views/widgets/category_card.dart';
import 'package:hungry_app/views/widgets/featured_recipe_card.dart';

class ExplorePage extends StatefulWidget {
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<String> appId = [
    "6a24089c", //api signup
    "69644634", //viraj
    "affcec2c", //third
    "90a4b561 ",
    "e310f916",
    "20374b02"
  ];
  List<String> key = [
    "93942b7a76a4324c516605ccf670bbfd",
    "439d9ae6316f0c8861e7049aef2a0ebb",
    "b03d8b98550e753c567c5f25c328817d",
    "dfd8b337602bbfb10eb47217a0dbd1de",
    "52d17ce3c37fcb27d927bf52ea44c021",
    "97bfa0f38a7f2f5ba13449647c2be3a0"
  ];

  final List<Recipe> featuredRecipe = [];

  getRandomRecpies() {
    List<String> ingredients = ['chicken', 'panner', 'mutton', 'potato'];
    var random = Random();
    int idx = random.nextInt(ingredients.length);
    getRecipies(ingredients[idx]);
  }

  getRecipies(searchQuery) async {
    print("object");
    featuredRecipe.clear();
    var random = Random();
    int idx = random.nextInt(appId.length);
    String url =
        "https://api.edamam.com/search?q=${searchQuery}&app_id=${appId[idx]}&app_key=${key[idx]}";

    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    if (jsonData['hits'] == null) {
      return;
    }
    jsonData['hits'].forEach((element) {
      Recipe recipe = Recipe(
          title: element['recipe']['label'],
          photo: element['recipe']['image'],
          tutorial: element['recipe']['url'],
          calories: element['recipe']['calories'],
          description: element['recipe']['source'],
          time: element['recipe']['totalTime'].toString(),
          ingridients: element['recipe']['ingredientLines']);
      featuredRecipe.add(recipe);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getRandomRecpies();
  }

  final Recipe popularRecipe = Recipe(
      title: 'title',
      photo: 'photo',
      calories: 0,
      time: 'time',
      description: '');

  final List<Recipe> sweetFoodRecommendationRecipe = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: false,
        title: const Text('Explore Recipe',
            style: TextStyle(
                fontFamily: 'inter',
                fontWeight: FontWeight.w400,
                fontSize: 16)),
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Category
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: MediaQuery.of(context).size.width,
            height: 245,
            color: AppColor.primary,
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CategoryScreen(
                              category: 'Healthy',
                            )));
                  },
                  child: CategoryCard(
                      title: 'Healthy',
                      image: const AssetImage('assets/images/healthy.jpg')),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CategoryScreen(
                              category: 'Drink',
                            )));
                  },
                  child: CategoryCard(
                      title: 'Drink',
                      image: const AssetImage('assets/images/drink.jpg')),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CategoryScreen(
                              category: 'Seafood',
                            )));
                  },
                  child: CategoryCard(
                      title: 'Seafood',
                      image: const AssetImage('assets/images/seafood.jpg')),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CategoryScreen(
                              category: 'Desert',
                            )));
                  },
                  child: CategoryCard(
                      title: 'Desert',
                      image: const AssetImage('assets/images/desert.jpg')),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CategoryScreen(
                              category: 'Spicy',
                            )));
                  },
                  child: CategoryCard(
                      title: 'Spicy',
                      image: const AssetImage('assets/images/spicy.jpg')),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CategoryScreen(
                              category: 'Meat',
                            )));
                  },
                  child: CategoryCard(
                      title: 'Meat',
                      image: const AssetImage('assets/images/meat.jpg')),
                ),
              ],
            ),
          ),

          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    'Todays sweet food to make your day happy ......',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                // Content
                featuredRecipe.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: MediaQuery.of(context).size.height - 200,
                        child: ListView.separated(
                          itemCount: featuredRecipe.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 16,
                            );
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FeaturedRecipeCard(
                                  data: featuredRecipe[index]),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
