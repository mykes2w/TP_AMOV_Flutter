import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../poi.dart';
import '../detail_page.dart';

class FavoritesView extends StatefulWidget {
  final List<Poi> allPois;
  const FavoritesView({super.key, required this.allPois});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  List<String> favoriteIds = []; //lista temporario para guardar os ids lidos do ficheiro

  @override
  void initState() {
    super.initState();
    _loadFavorites(); //inicia os favoritos
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteIds = prefs.getStringList('favorites') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final myFavorites = widget.allPois.where((p) => favoriteIds.contains(p.id.toString())).toList(); //criamos uma lsita que contem os favoritos

    return Scaffold(
      appBar: AppBar(title: const Text("Meus Favoritos")),
      body: myFavorites.isEmpty
          ? const Center(child: Text("Ainda não tens favoritos!"))
          : ListView.builder(
        itemCount: myFavorites.length,
        itemBuilder: (context, index) {
          final poi = myFavorites[index];
          return ListTile(
            leading: CircleAvatar(backgroundImage: AssetImage(poi.image)),
            title: Text(poi.name),
            subtitle: Text(poi.shortDescription),
            trailing: const Icon(Icons.favorite, color: Colors.red),
            onTap: () { //quando voltamos da pagina dos detalhes para dar favorito ele faz o then() para dar laod e atualizar
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DetailPage(poi: poi)),
              ).then((_) => _loadFavorites());
            },
          );
        },
      ),
    );
  }
}
