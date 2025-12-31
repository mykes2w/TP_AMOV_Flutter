import 'package:flutter/material.dart';
import '../poi.dart';
import '../detail_page.dart';

class CategoryPointsPage extends StatelessWidget {
  final String category;
  final List<Poi> allPois;

  const CategoryPointsPage({super.key, required this.category, required this.allPois});

  @override
  Widget build(BuildContext context) {
    final categoryPois = allPois.where((p) => p.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: categoryPois.length,
        itemBuilder: (context, index) {
          final poi = categoryPois[index];

          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DetailPage(poi: poi)),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              elevation: 3,
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                      child: Image.asset(
                        poi.image,
                        fit: BoxFit.cover,
                        errorBuilder: (c,e,s) => const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(poi.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text("€ ${poi.averagePrice}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}