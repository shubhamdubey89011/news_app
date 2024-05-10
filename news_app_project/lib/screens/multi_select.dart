import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
  //import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:news_app/blocs/categories_bloc.dart';
import 'package:news_app/models/category.dart';
import 'package:news_app/pages/category_based_articles.dart';
import 'package:news_app/pages/home.dart';
import 'package:news_app/utils/cached_image_with_dark.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/widgets/round_button.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class SelectMultiCategories extends StatefulWidget {
  SelectMultiCategories({Key? key}) : super(key: key);

  @override
  _SelectMultiCategoriesState createState() => _SelectMultiCategoriesState();
}

class _SelectMultiCategoriesState extends State<SelectMultiCategories>
    with AutomaticKeepAliveClientMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController? controller;
  List<CategoryModel> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      controller = new ScrollController()..addListener(_scrollListener);
      context.read<CategoriesBloc>().getData(mounted);
    });
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<CategoriesBloc>();

    if (!db.isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        context.read<CategoriesBloc>().setLoading(true);
        context.read<CategoriesBloc>().getData(mounted);
      }
    }
  }

  // Method to store selected categories in Firestore
  void storeSelectedCategories(List<CategoryModel> selectedCategories) async {
    final user = FirebaseAuth.instance.currentUser;
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    List<String> categoryNames =
        selectedCategories.map((category) => category.name!).toList();

    try {
      await userRef.set({
        'selectedCategories': categoryNames,
      }, SetOptions(merge: true));
      print('Selected categories stored successfully');
    } catch (e) {
      print('Error storing selected categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cb = context.watch<CategoriesBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text('Choose at least 3 Categories '),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Feather.rotate_cw,
              size: 22,
            ),
            onPressed: () {
              context.read<CategoriesBloc>().onRefresh(mounted);
            },
          )
        ],
      ),
      body: Column(
        children: [
          RefreshIndicator(
            child: cb.hasData == false
                ? ListView(
                    children: [
                     
                      EmptyPage(
                          icon: Feather.clipboard,
                          message: 'no Categories found',
                          message1: ''),
                    ],
                  )
                : MultiSelectDialogField<CategoryModel>(
                    items: cb.data
                        .map((category) => MultiSelectItem<CategoryModel>(
                              category,
                              category.name!,
                            ))
                        .toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (List<CategoryModel?> values) {
                      selectedCategories = values
                          .where((element) => element != null)
                          .map((e) => e!)
                          .toList();
                      // Call the method to store selected categories
                      storeSelectedCategories(selectedCategories);
                    },
                    chipDisplay: MultiSelectChipDisplay(scroll: true,scrollBar: HorizontalScrollBar(),
                      chipColor: Colors.blue.shade100,
                      textStyle: TextStyle(color: Colors.blue),
                      onTap: (value) {
                        setState(() {
                          selectedCategories.remove(value);
                        });
                      },
                    ),
                    searchable: true,
                    buttonText: Text('Select Categories'),
                    title: Text('Categories'),
                  ),
            onRefresh: () async {
              context.read<CategoriesBloc>().onRefresh(mounted);
            },
          ),
           SizedBox(
                        height: 500,
                      ),
          RoundButton(
              title: 'Get Started',
              onTap: () {
                Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  HomePage()),
  );
      
              },
              color: Colors.black),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


