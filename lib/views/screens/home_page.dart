import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:multi_dropdown/multiselect_dropdown.dart';

import 'package:hungry_app/models/core/recipe.dart';
import 'package:hungry_app/views/screens/profile_page.dart';
import 'package:hungry_app/views/utils/AppColor.dart';
import 'package:hungry_app/views/widgets/custom_app_bar.dart';
import 'package:hungry_app/views/widgets/featured_recipe_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  getRandomRecpies() {
    List<String> ingredients = ['chicken', 'panner', 'mutton', 'potato'];
    var random = Random();
    int idx = random.nextInt(ingredients.length);
    getRecipies(ingredients[idx]);
  }

  @override
  void initState() {
    super.initState();
    getRandomRecpies();
  }

  TextEditingController searchInputController = TextEditingController();
  List<ValueItem> milkProducts = [
    const ValueItem(label: 'Milk', value: 'Milk'),
    const ValueItem(label: 'Cheese', value: 'Cheese'),
    const ValueItem(label: 'Butter', value: 'Butter'),
    const ValueItem(label: 'Yogurt', value: 'Yogurt'),
    const ValueItem(label: 'Cream', value: 'Cream'),
    const ValueItem(label: 'Ice Cream', value: 'Ice Cream'),
    const ValueItem(label: 'Chocolate', value: 'Chocolate'),
  ];
  List<ValueItem> selectedMilkProducts = [];

  List<ValueItem> meatProducts = [
    const ValueItem(label: 'Beef', value: 'Beef'),
    const ValueItem(label: 'Chicken', value: 'Chicken'),
    const ValueItem(label: 'Pork', value: 'Pork'),
    const ValueItem(label: 'Lamb', value: 'Lamb'),
    const ValueItem(label: 'Turkey', value: 'Turkey'),
    const ValueItem(label: 'Duck', value: 'Duck'),
    const ValueItem(label: 'Fish', value: 'Fish')
  ];
  List<ValueItem> selectedMeatProducts = [];

  List<ValueItem> fruitsAndVegetables = [
    const ValueItem(label: 'Apple', value: 'Apple'),
    const ValueItem(label: 'Banana', value: 'Banana'),
    const ValueItem(label: 'Orange', value: 'Orange'),
    const ValueItem(label: 'Mango', value: 'Mango'),
    const ValueItem(label: 'Pineapple', value: 'Pineapple'),
    const ValueItem(label: 'Grapes', value: 'Grapes'),
    const ValueItem(label: 'Strawberry', value: 'Strawberry'),
    const ValueItem(label: 'Watermelon', value: 'Watermelon'),
    const ValueItem(label: 'Tomato', value: 'Tomato'),
    const ValueItem(label: 'Potato', value: 'Potato'),
    const ValueItem(label: 'Onion', value: 'Onion'),
    const ValueItem(label: 'Carrot', value: 'Carrot'),
    const ValueItem(label: 'Cucumber', value: 'Cucumber'),
    const ValueItem(label: 'Broccoli', value: 'Broccoli'),
  ];
  List<ValueItem> selectedFruitsAndVegetables = [];

  List<ValueItem> grainsAndBread = [
    const ValueItem(label: 'Rice', value: 'Rice'),
    const ValueItem(label: 'Wheat', value: 'Wheat'),
    const ValueItem(label: 'Bread', value: 'Bread'),
    const ValueItem(label: 'Oats', value: 'Oats'),
    const ValueItem(label: 'Barley', value: 'Barley'),
    const ValueItem(label: 'Corn', value: 'Corn'),
    const ValueItem(label: 'Rye', value: 'Rye'),
  ];
  List<ValueItem> selectedGrainsAndBread = [];

  getRecipies(searchQuery) async {
    setState(() {
      featuredRecipe.clear();
      isLoading = true;
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Hungry?',
            style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w700)),
        showProfilePhoto: true,
        profilePhoto: const AssetImage('assets/images/pp.png'),
        profilePhotoOnPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProfilePage()));
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height + 100,
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                height: 345,
                color: AppColor.primary,
              ),
              // Section 1 - Content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      'What Do you want to eat today',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    MultiSelectDropDown(
                        hint: 'Milk Products',
                        onOptionSelected: (List<ValueItem> selectedOptions) {
                          selectedMilkProducts = selectedOptions;
                        },
                        options: milkProducts),
                    const SizedBox(height: 10),
                    MultiSelectDropDown(
                        hint: 'Meat Products',
                        onOptionSelected: (List<ValueItem> selectedOptions) {
                          selectedMeatProducts = selectedOptions;
                        },
                        options: meatProducts),
                    const SizedBox(height: 10),
                    MultiSelectDropDown(
                        hint: 'Fruits and Vegetables',
                        onOptionSelected: (List<ValueItem> selectedOptions) {
                          selectedFruitsAndVegetables = selectedOptions;
                        },
                        options: fruitsAndVegetables),
                    const SizedBox(height: 10),
                    MultiSelectDropDown(
                        hint: 'Grains and Bread',
                        onOptionSelected: (List<ValueItem> selectedOptions) {
                          selectedGrainsAndBread = selectedOptions;
                        },
                        options: grainsAndBread),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        if (selectedFruitsAndVegetables.length +
                                selectedMeatProducts.length +
                                selectedMilkProducts.length +
                                selectedGrainsAndBread.length >=
                            2) {
                          String searchQuery =
                              '${selectedFruitsAndVegetables.map((e) => e.value).join(',')},${selectedMeatProducts.map((e) => e.value).join(',')},${selectedMilkProducts.map((e) => e.value).join(',')},${selectedGrainsAndBread.map((e) => e.value).join(',')}';
                          getRecipies(searchQuery);
                        } else {
                          // Show a snackbar or any other indication to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select at least 2 items.'),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.primarySoft,
                        ),
                        child: Center(
                          child: Text(
                            'Search',
                            style: TextStyle(
                              color: AppColor.secondary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    featuredRecipe.isEmpty
                        ? Center(
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text('No Data Found'),
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: MediaQuery.of(context).size.height - 350,
                            child: ListView.separated(
                              itemCount: featuredRecipe.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
