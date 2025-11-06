import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pokemon_viewmodel.dart';
import 'pokemon_detail_screen.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => PokemonScreenState();
}

class PokemonScreenState extends State<PokemonScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonViewModel>().fetchPokemons();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PokemonViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Pokédex'),
            backgroundColor: Colors.red,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _searchController,
                    onChanged: viewModel.searchPokemon,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Szukaj po nazwie/ID...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: _buildBody(viewModel),
        );
      },
    );
  }

  Widget _buildBody(PokemonViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(viewModel.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: viewModel.fetchPokemons,
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      );
    }

    final list = viewModel.filteredPokemons;

    if (list.isEmpty) {
      return const Center(child: Text('Brak wyników'));
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final pokemon = list[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Image.network(
              pokemon.imageUrl,
              width: 50,
              height: 50,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.catching_pokemon),
            ),
            title: Text(
              pokemon.name.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('ID: ${pokemon.id}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PokemonDetailScreen(id: pokemon.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
