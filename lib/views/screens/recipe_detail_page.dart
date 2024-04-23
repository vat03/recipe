import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hungry_app/models/core/recipe.dart';
import 'package:hungry_app/views/screens/full_screen_image.dart';
import 'package:hungry_app/views/utils/AppColor.dart';
import 'package:hungry_app/views/widgets/ingridient_tile.dart';
import 'package:hungry_app/views/widgets/review_tile.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe data;
  const RecipeDetailPage({super.key, required this.data});

  @override
  // ignore: library_private_types_in_public_api
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(() {
      changeAppBarColor(_scrollController);
    });
  }

  Color appBarColor = Colors.transparent;

  changeAppBarColor(ScrollController scrollController) {
    if (scrollController.position.hasPixels) {
      if (scrollController.position.pixels > 2.0) {
        setState(() {
          appBarColor = AppColor.primary;
        });
      }
      if (scrollController.position.pixels <= 2.0) {
        setState(() {
          appBarColor = Colors.transparent;
        });
      }
    } else {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  // fab to write review
  showFAB(TabController tabController) {
    int reviewTabIndex = 2;
    if (tabController.index == reviewTabIndex) {
      return true;
    }
    return false;
  }

  Future<void> saveBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const String bookmarkKey = 'bookmarked_recipes';
    // Retrieve existing bookmarks
    List<String>? bookmarkedRecipes = prefs.getStringList(bookmarkKey);

    bookmarkedRecipes ??= [];

    String recipeJson = jsonEncode(widget.data.toJson());

    bookmarkedRecipes.add(recipeJson);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to bookmarks'),
      ),
    );
    await prefs.setStringList(bookmarkKey, bookmarkedRecipes);
    // show a toast
  }

  Future<void> launchUrl(String urlString) async {
    await launch(urlString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await saveBookmark();
              },
              icon: SvgPicture.asset('assets/icons/bookmark.svg',
                  color: Colors.white)),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      // Post Review FAB
      body: ListView(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Recipe Image
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FullScreenImage(
                      image: Image.network(widget.data.photo,
                          fit: BoxFit.cover))));
            },
            child: Container(
              height: 280,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.data.photo),
                      fit: BoxFit.cover)),
              child: Container(
                decoration: BoxDecoration(gradient: AppColor.linearBlackTop),
                height: 280,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          // Section 2 - Recipe Info
          GestureDetector(
            onTap: () {
              launchUrl(widget.data.tutorial!);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                  top: 20, bottom: 30, left: 16, right: 16),
              color: AppColor.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Calories and Time
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/fire-filled.svg',
                        color: Colors.white,
                        width: 16,
                        height: 16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Text(
                          widget.data.calories.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.alarm, size: 16, color: Colors.white),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Text(
                          widget.data.time,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  // Recipe Title
                  Container(
                    margin: const EdgeInsets.only(bottom: 12, top: 16),
                    child: Text(
                      widget.data.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'inter'),
                    ),
                  ),
                  // Recipe Description
                  Text(
                    widget.data.description,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 150 / 100),
                  ),
                ],
              ),
            ),
          ),
          // Tabbar ( Ingridients, Tutorial, Reviews )
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            color: AppColor.secondary,
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                });
              },
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.6),
              labelStyle: const TextStyle(
                  fontFamily: 'inter', fontWeight: FontWeight.w500),
              indicatorColor: Colors.black,
              tabs: const [
                Tab(
                  text: 'Ingridients',
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: widget.data.ingridients!.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return IngridientTile(
                data: widget.data.ingridients![index],
              );
            },
          ),
          // IndexedStack based on TabBar index
          // IndexedStack(
          //   index: _tabController.index,
          //   children: [
          //     // Ingridients
          //     if (widget.data.ingridients != null)
          //       ListView.builder(
          //         shrinkWrap: true,
          //         padding: EdgeInsets.zero,
          //         itemCount: widget.data.ingridients!.length,
          //         physics: const NeverScrollableScrollPhysics(),
          //         itemBuilder: (context, index) {
          //           return IngridientTile(
          //             data: widget.data.ingridients![index],
          //           );
          //         },
          //       ),
          //     // Tutorials
          //     if (widget.data.tutorial != null)
          //       ListView.builder(
          //         shrinkWrap: true,
          //         padding: EdgeInsets.zero,
          //         itemCount: widget.data.tutorial!.length,
          //         physics: const NeverScrollableScrollPhysics(),
          //         itemBuilder: (context, index) {
          //           return Container(
          //             margin: const EdgeInsets.only(bottom: 16),
          //             child: Row(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Container(
          //                   width: 30,
          //                   height: 30,
          //                   alignment: Alignment.center,
          //                   decoration: BoxDecoration(
          //                       color: AppColor.primary,
          //                       borderRadius: BorderRadius.circular(5)),
          //                   child: Text(
          //                     '${index + 1}',
          //                     style: const TextStyle(
          //                         color: Colors.white,
          //                         fontSize: 12,
          //                         fontWeight: FontWeight.w600),
          //                   ),
          //                 ),
          //                 const SizedBox(width: 10),
          //                 Expanded(
          //                   child: Text(
          //                     widget.data.tutorial![index],
          //                     style: const TextStyle(
          //                         color: Colors.black,
          //                         fontSize: 14,
          //                         height: 150 / 100),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           );
          //         },
          //       ),
          //     // Reviews
          //     if (widget.data.reviews != null)
          //       ListView.builder(
          //         shrinkWrap: true,
          //         padding: EdgeInsets.zero,
          //         itemCount: widget.data.reviews!.length,
          //         physics: const NeverScrollableScrollPhysics(),
          //         itemBuilder: (context, index) {
          //           return ReviewTile(data: widget.data.reviews![index]);
          //         },
          //       )
          //   ],
          // ),
        ],
      ),
    );
  }
}
