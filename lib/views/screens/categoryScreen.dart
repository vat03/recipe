// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:hungry_app/models/core/recipe.dart';
import 'package:hungry_app/views/widgets/featured_recipe_card.dart';
import 'package:hungry_app/views/widgets/recipe_tile.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  const CategoryScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isLoading = true;
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
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getRecipies(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.only(top: 4),
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
                    child: FeaturedRecipeCard(data: featuredRecipe[index]),
                  );
                },
              ),
            ),
    );
  }
}
