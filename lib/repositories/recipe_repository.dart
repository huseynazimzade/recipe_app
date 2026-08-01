import '../models/recipe_model.dart';
import '../providers/api_service.dart';

class RecipeRepository {
  final ApiService _apiService = ApiService();

  Future<List<RecipeModel>> getRecipesByLetter(String letter) async {
    final rawList = await _apiService.fetchRecipes(letter);
    return rawList
    .map((json) => RecipeModel.fromJson(json as Map<String, dynamic>))
    .toList();
  }
}
