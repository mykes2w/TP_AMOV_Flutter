import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'poi.dart';

import 'screens/home.dart';
import 'screens/categories.dart';
import 'screens/points.dart';
import 'screens/favorites.dart';

void main() {
  runApp(const GuiaApp());
}

class GuiaApp extends StatelessWidget {
  const GuiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guia de Hamburgo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Poi> allPois = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPois();
  }

  Future<void> loadPois() async {
    try {
      final String response = await rootBundle.loadString('assets/data/poi.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        allPois = data.map((jsonItem) => Poi.fromJson(jsonItem)).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Erro JSON: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToPointsTab() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeView(onExplorePressed: _goToPointsTab),
      CategoriesView(allPois: allPois),
      PointsView(allPois: allPois),
      FavoritesView(allPois: allPois),
    ];

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.category_outlined), selectedIcon: Icon(Icons.category), label: 'Categorias'),
          NavigationDestination(icon: Icon(Icons.place_outlined), selectedIcon: Icon(Icons.place), label: 'Pontos'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Favoritos'),
        ],
      ),
    );
  }
}