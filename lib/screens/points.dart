import 'package:flutter/material.dart';
import '../poi.dart';
import '../detail_page.dart';

class PointsView extends StatelessWidget {
  final List<Poi> allPois;
  const PointsView({super.key, required this.allPois});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todos os Locais")),
      body: ListView.builder(
        itemCount: allPois.length,
        itemBuilder: (context, index) {
          final poi = allPois[index];
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
                      child: Image.asset(poi.image, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.broken_image)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(poi.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(poi.category, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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