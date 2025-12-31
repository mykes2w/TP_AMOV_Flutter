import 'package:flutter/material.dart';
import '../poi.dart';
import 'filteredcategories.dart';

class CategoriesView extends StatelessWidget {
  final List<Poi> allPois;
  const CategoriesView({super.key, required this.allPois});

  @override
  Widget build(BuildContext context) {
    final categories = allPois.map((e) => e.category).toSet().toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Categorias")),
      body: ListView.builder(
        itemCount: categories.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final count = allPois.where((p) => p.category == cat).length;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.category, color: Colors.blue[800]),
              ),
              title: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Chip(label: Text("$count locais")),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategoryPointsPage(category: cat, allPois: allPois),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}