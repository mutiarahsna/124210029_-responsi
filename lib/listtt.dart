import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:responsi/details.dart';

class FoodItemsPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  FoodItemsPage({required this.categoryId, required this.categoryName});

  @override
  _FoodItemsPageState createState() => _FoodItemsPageState();
}

class _FoodItemsPageState extends State<FoodItemsPage> {
  List<FoodItem> foodItems = [];

  @override
  void initState() {
    super.initState();
    fetchFoodItems();
  }

  Future<void> fetchFoodItems() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.categoryName}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> mealsData = data['meals'];
      setState(() {
        foodItems = mealsData.map((meal) => FoodItem.fromJson(meal)).toList();
      });
    } else {
      throw Exception('Failed to load food items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Items - ${widget.categoryName}'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FoodDetailPage(foodItem: foodItems[index]),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      foodItems[index].strMealThumb,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(foodItems[index].strMeal),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FoodItem {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;

  FoodItem({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
    );
  }
}
