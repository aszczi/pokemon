class PokemonDetail {
  final int id;
  final String name;
  final int height; // dm
  final int weight; // hg
  final List<String> types;
  final List<String> abilities;
  final String? spriteUrl;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.spriteUrl,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      types: (json['types'] as List)
          .map((e) => e['type']['name'] as String)
          .toList(),
      abilities: (json['abilities'] as List)
          .map((e) => e['ability']['name'] as String)
          .toList(),
      spriteUrl: json['sprites']?['front_default'] as String?,
    );
  }

  double get heightMeters => height / 10.0;
  double get weightKg => weight / 10.0;
}
