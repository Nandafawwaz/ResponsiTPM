import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class FoodDetailScreen extends StatefulWidget {
  final String foodId;

  FoodDetailScreen({required this.foodId});

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  Map<String, dynamic> foodDetails = {};

  @override
  void initState() {
    super.initState();
    fetchFoodDetails();
  }

  Future<void> fetchFoodDetails() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget
            .foodId}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        foodDetails = data['meals'][0];
      });
    }
  }

  Future<void> launchYoutubeVideo() async {
    final youtubeUrl = foodDetails['strYoutube'];
    if (await canLaunch(youtubeUrl)) {
      await launch(youtubeUrl);
    } else {
      print('Could not launch $youtubeUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Detail', style: TextStyle(fontSize: 20.0)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                foodDetails['strMeal'] ?? '',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Image.network(
              foodDetails['strMealThumb'] ?? '',
              width: 200.0,
              height: 200.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Category: ${foodDetails['strCategory'] ?? ''}',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Area: ${foodDetails['strArea'] ?? ''}',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                foodDetails['strInstructions'] ?? '',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            ElevatedButton(
              onPressed: launchYoutubeVideo,
              child: Text('Lihat Youtube'),
            ),
          ],
        ),
      ),
    );
  }
}