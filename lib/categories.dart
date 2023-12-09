import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:responsi/listtt.dart';

class Kategori extends StatefulWidget {
  @override
  _KategoriState createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> categoriesData = data['categories'];
      setState(() {
        categories = categoriesData.map((category) => Category.fromJson(category)).toList();
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Function to navigate to FoodItemsPage
  void navigateToFoodItemsPage(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodItemsPage(
          categoryId: category.idCategory,
          categoryName: category.strCategory,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                // Call the navigateToFoodItemsPage function when the card is tapped
                navigateToFoodItemsPage(categories[index]);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(categories[index].strCategory, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Image.network(categories[index].strCategoryThumb, height: 150, width: double.infinity, fit: BoxFit.contain),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(categories[index].strCategoryDescription),
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

class Category {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  Category({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategory: json['idCategory'],
      strCategory: json['strCategory'],
      strCategoryThumb: json['strCategoryThumb'],
      strCategoryDescription: json['strCategoryDescription'],
    );
  }
}
