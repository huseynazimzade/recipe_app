class RecipeModel {
  final String id;
  final String name;
  final String category;
  final String instructions;
  final String thumbUrl;

  RecipeModel({
    required this.id,
    required this.name,
    required this.category,
    required this.instructions,
    required this.thumbUrl,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['idMeal'] as String? ?? '',
      name: json['strMeal'] as String? ?? 'Adsız Resept',
      category: json['strCategory'] as String? ?? 'Ümumi',
      instructions: json['strInstructions'] as String? ?? 'Təlimat yoxdur.',
      thumbUrl: json['strMealThumb'] as String? ?? '',
    );
  }
}
