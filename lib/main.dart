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
  List<Poi> allPois = [];//lista que vai guardar todos os monumentos da lista json
  bool isLoading = true; //flag para saber se a app ainda esta a ler o ficheiro

  @override
  void initState() {
    super.initState();
    loadPois();
  }
  //future é um objeto que diz basicamente que posso nao ter o resultado ja , mas vou ter no futuro
  Future<void> loadPois() async {//basicamente o async é para avisares o flutter que esta funçao vai carregar ficheiros demorados 
    try {
      final String response = await rootBundle.loadString('assets/data/poi.json'); //basicamente aqui o await serve para a aplicaçao continuar a desenhar o ecra mesmo que o ficheiro json n tenha carregado
      final List<dynamic> data = json.decode(response); //transforma o texto em dados que o dart percebe
      setState(() {
        allPois = data.map((jsonItem) => Poi.fromJson(jsonItem)).toList(); //Usa o 'factory' do poi.dart para criar objetos Reais da classe Po
        isLoading = false; //ja carregou e coloca a false
      });
    } catch (e) {
      print("Erro JSON: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; //muda o numero da aba e redesenha o ecra
    });
  }

  void _goToPointsTab() {
    setState(() {
      _selectedIndex = 2; //salta para a aba de pontos
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [ //cria as paginas e cada uma é 0,1,2,3
      HomeView(onExplorePressed: _goToPointsTab),
      CategoriesView(allPois: allPois),
      PointsView(allPois: allPois),
      FavoritesView(allPois: allPois),
    ];

    if (isLoading) { //enquanto estiver a carregar coloca uma bola a dizer 
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: pages[_selectedIndex], //mostra a pagina que esta carregada
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
