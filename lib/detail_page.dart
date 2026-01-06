import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'poi.dart';

class DetailPage extends StatefulWidget {
  final Poi poi; //recebe o monumento que foi clicado e passado para este ecra

  const DetailPage({super.key, required this.poi}); //recebe o objeto POI e obrigatoriamente tem de dar

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus(); // ao abrir a pagina verifica se esta favorito
  }

  Future<void> _checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance(); //abre o ficheiro shared preferences
    final List<String> favorites = prefs.getStringList('favorites') ?? []; //vai buscar a lista de favoritos ao ficheiro e caso nao tenha nada devolve uma lista vazia

    setState(() {
      isFavorite = favorites.contains(widget.poi.id.toString()); //verifica se o id do monumento consta na lista
    });
  }

  Future<void> _toggleFavorite() async { //quando clica no botao
    final prefs = await SharedPreferences.getInstance(); //cria o ficheiro shared preferences para guardar os favoritos
    final List<String> favorites = prefs.getStringList('favorites') ?? [];
    String id = widget.poi.id.toString();

    if (isFavorite) {  //se o objeto for favorito remove 
      favorites.remove(id);
    } else { //se nao adiciona
      favorites.add(id);
    }
    // Grava a lista atualizada fisicamente no armazenamento do telemóvel
    await prefs.setStringList('favorites', favorites);

    setState(() {
      isFavorite = !isFavorite; // Inverte o valor visual (true -> false e vice-versa)
    });
    //mostrar a barra no fundo do ecra com o aviso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? 'Adicionado aos Favoritos' : 'Removido dos Favoritos'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.poi.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
              size: 30,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      // SingleChildScrollView: evita que a app crash se o texto for maior que o ecrã
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.poi.image,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey,
                  child: const Center(child: Icon(Icons.broken_image, size: 50)),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(widget.poi.category),
                        backgroundColor: Colors.blue.shade100,
                      ),
                      Text(
                        widget.poi.averagePrice == 0 ? "Grátis" : "€ ${widget.poi.averagePrice}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.orange),
                      const SizedBox(width: 10),
                      Text("Horário: ${widget.poi.schedule}", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(widget.poi.location, style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  const Divider(height: 40),
                  const Text(
                    "Sobre este local:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.poi.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
