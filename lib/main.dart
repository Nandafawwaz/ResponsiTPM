import 'package:flutter/material.dart';
import 'package:untitled1/listmeals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Categories',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FoodCategoriesScreen(),
    );
  }
}

class FoodCategoriesScreen extends StatefulWidget {
  @override
  _FoodCategoriesScreenState createState() => _FoodCategoriesScreenState();
}

class _FoodCategoriesScreenState extends State<FoodCategoriesScreen> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        categories = data['categories'];
      });
    }
  }

  void navigateToCategoryFoods(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryFoodsScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Category', style: TextStyle(fontSize: 20.0)),
        centerTitle: true, // Center the title horizontally
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];
          return ListTile(
            onTap: () => navigateToCategoryFoods(category['strCategory']),
            leading: Image.network(
              category['strCategoryThumb'],
              width: 100.0,
              height: 100.0,
            ),
            title: Text(category['strCategory']),
          );
        },
      ),
    );
  }
}


