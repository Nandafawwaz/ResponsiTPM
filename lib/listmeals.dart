import 'package:flutter/material.dart';
import 'package:untitled1/mealsdetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryFoodsScreen extends StatefulWidget {
  final String category;

  CategoryFoodsScreen({required this.category});

  @override
  _CategoryFoodsScreenState createState() => _CategoryFoodsScreenState();
}

class _CategoryFoodsScreenState extends State<CategoryFoodsScreen> {
  List<dynamic> foods = [];

  @override
  void initState() {
    super.initState();
    fetchCategoryFoods();
  }

  Future<void> fetchCategoryFoods() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget
            .category}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        foods = data['meals'];
      });
    }
  }


  void navigateToFoodDetail(String foodId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailScreen(foodId: foodId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category, style: TextStyle(fontSize: 20.0)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (BuildContext context, int index) {
          final food = foods[index];
          return ListTile(
            onTap: () => navigateToFoodDetail(food['idMeal']),
            leading: Image.network(
              food['strMealThumb'],
              width: 60.0,
              height: 60.0,
            ),
            title: Text(food['strMeal']),
          );
        },
      ),
    );
  }
}