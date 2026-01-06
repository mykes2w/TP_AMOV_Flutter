import 'package:flutter/material.dart';
import '../poi.dart';
import 'filteredcategories.dart';

class CategoriesView extends StatelessWidget {
  final List<Poi> allPois;
  const CategoriesView({super.key, required this.allPois});

  @override
  Widget build(BuildContext context) {
    final categories = allPois.map((e) => e.category).toSet().toList(); //map.e transforma a lista de monumentos numa lsita de nomes das categorias
    //.toset é para caso haja repetiçao ele escreva so 1
    //.toList Transforma de volta em lista para o ListView poder usar.

    return Scaffold(
      appBar: AppBar(title: const Text("Categorias")),
      body: ListView.builder(
        itemCount: categories.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final cat = categories[index]; //vai buscar a categoria atual
          final count = allPois.where((p) => p.category == cat).length; //procura qts elementos pertencem a esta categoria

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
