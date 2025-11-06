import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';

class PokemonViewModel extends ChangeNotifier {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  // LISTA GŁÓWNA I FILTROWANA
  bool isLoading = false;
  String? errorMessage;
  List<Pokemon> pokemons = [];
  List<Pokemon> filteredPokemons = [];

  // STAN SZCZEGÓŁÓW
  bool isDetailLoading = false;
  String? detailErrorMessage;
  PokemonDetail? pokemonDetail;

  Future<void> fetchPokemons() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // pobierz więcej niż 20, żeby wyszukiwarka miała sens
      final response = await http.get(
        Uri.parse('$baseUrl/pokemon?limit=200'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        pokemons = (data['results'] as List)
            .map((e) => Pokemon.fromJson(e))
            .toList();

        filteredPokemons = List<Pokemon>.from(pokemons);
      } else {
        errorMessage = 'Błąd: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Błąd połączenia: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPokemonDetail(int id) async {
    isDetailLoading = true;
    detailErrorMessage = null;
    pokemonDetail = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pokemon/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        pokemonDetail = PokemonDetail.fromJson(data);
      } else {
        detailErrorMessage = 'Błąd: ${response.statusCode}';
      }
    } catch (e) {
      detailErrorMessage = 'Błąd połączenia: $e';
    } finally {
      isDetailLoading = false;
      notifyListeners();
    }
  }

  // WYSZUKIWANIE po nazwie lub dokładnym ID
  void searchPokemon(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      filteredPokemons = List<Pokemon>.from(pokemons);
    } else {
      filteredPokemons = pokemons.where((p) {
        final name = p.name.toLowerCase();
        final idStr = p.id.toString();
        return name.contains(q) || idStr == q;
      }).toList();
    }
    notifyListeners();
  }
}
