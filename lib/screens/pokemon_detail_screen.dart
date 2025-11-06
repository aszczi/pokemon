import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pokemon_viewmodel.dart';

class PokemonDetailScreen extends StatefulWidget {
  final int id;
  const PokemonDetailScreen({super.key, required this.id});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonViewModel>().fetchPokemonDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PokemonViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Szczegóły #${widget.id}'),
          ),
          body: _buildBody(vm),
        );
      },
    );
  }

  Widget _buildBody(PokemonViewModel vm) {
    if (vm.isDetailLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.detailErrorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(vm.detailErrorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => vm.fetchPokemonDetail(widget.id),
                child: const Text('Spróbuj ponownie'),
              ),
            ],
          ),
        ),
      );
    }

    final d = vm.pokemonDetail;
    if (d == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (d.spriteUrl != null)
            Image.network(
              d.spriteUrl!,
              width: 140,
              height: 140,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.catching_pokemon, size: 100),
            )
          else
            const Icon(Icons.catching_pokemon, size: 100),
          const SizedBox(height: 12),
          Text(
            d.name.toUpperCase(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: d.types
                .map((t) => Chip(
                      label: Text(t),
                      avatar: const Icon(Icons.bolt),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.straighten),
              title: Text('Wzrost: ${d.heightMeters.toStringAsFixed(1)} m'),
              subtitle: Text('Waga: ${d.weightKg.toStringAsFixed(1)} kg'),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Zdolności',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...d.abilities.map((a) => Row(
                        children: [
                          const Icon(Icons.star_border, size: 18),
                          const SizedBox(width: 6),
                          Text(a),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
