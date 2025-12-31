import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  final VoidCallback onExplorePressed;
  const HomeView({super.key, required this.onExplorePressed});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _timeString = "--:--";
  String _weatherInfo = "--°C";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startClock();
    _fetchWeather();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      final DateTime now = DateTime.now().toUtc().add(const Duration(hours: 1));
      if (mounted) {
        setState(() {
          _timeString = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
        });
      }
    });
  }

  Future<void> _fetchWeather() async {
    try {
      final url = Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=53.55&longitude=9.99&current_weather=true');
      final response = await http.get(url);
      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        setState(() {
          _weatherInfo = "${data['current_weather']['temperature'].round()}°C";
        });
      }
    } catch (e) { print(e); }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 75),
          const Text("HAMBURGO", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 5),
          Text("Alemanha", style: TextStyle(fontSize: 18, color: Colors.grey[600])),

          const Spacer(flex: 1),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
              image: const DecorationImage(
                image: AssetImage('assets/images/capa.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Icon(Icons.access_time, size: 30, color: Colors.blue),
                  const SizedBox(height: 5),
                  Text(_timeString, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("Hora Local", style: TextStyle(color: Colors.grey)),
                ],
              ),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              Column(
                children: [
                  const Icon(Icons.wb_sunny, size: 30, color: Colors.orange),
                  const SizedBox(height: 5),
                  Text(_weatherInfo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("Temperatura", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),

          const Spacer(flex: 2),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: widget.onExplorePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                ),
                child: const Text("EXPLORAR AGORA", style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          const SizedBox(height: 75),
        ],
      ),
    );
  }
}