import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/pokemon_screen.dart';
import 'viewmodels/pokemon_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PokemonViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pokédex',
        theme: ThemeData(
          useMaterial3: false, // klasyczny AppBar
          primarySwatch: Colors.red,
        ),
        home: const PokemonScreen(),
      ),
    );
  }
}
