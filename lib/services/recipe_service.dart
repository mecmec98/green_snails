import '../models/recipe.dart';
import 'api_client.dart';

class RecipeService {
  final ApiClient _api = ApiClient();

  int _parseTotal(dynamic total) {
    if (total == null) return 0;
    if (total is int) return total;
    if (total is String) return int.tryParse(total) ?? 0;
    return 0;
  }

  List<Recipe> _parseRecipeList(dynamic data) {
    if (data == null || data is! List) return [];
    return (data as List).map((r) => Recipe.fromJson(r as Map<String, dynamic>)).toList();
  }

  Future<({List<Recipe> recipes, int total})> getRecipes({int page = 1, int limit = 20, String? search, String? category}) async {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null) params['search'] = search;
    if (category != null) params['category'] = category;

    final response = await _api.get('/recipes', queryParams: params);
    final recipes = _parseRecipeList(response['recipes']);
    return (recipes: recipes, total: _parseTotal(response['total']));
  }

  Future<({List<Recipe> recipes, int total})> getMyRecipes({int page = 1, int limit = 20}) async {
    final response = await _api.get('/recipes/my', queryParams: {'page': page.toString(), 'limit': limit.toString()});
    final recipes = _parseRecipeList(response['recipes']);
    return (recipes: recipes, total: _parseTotal(response['total']));
  }

  Future<({List<Recipe> recipes, int total})> getFavorites({int page = 1, int limit = 20}) async {
    final response = await _api.get('/recipes/favorites', queryParams: {'page': page.toString(), 'limit': limit.toString()});
    final recipes = _parseRecipeList(response['recipes']);
    return (recipes: recipes, total: _parseTotal(response['total']));
  }

  Future<Recipe> getRecipe(String id) async {
    final response = await _api.get('/recipes/$id');
    return Recipe.fromJson(response['recipe'] as Map<String, dynamic>);
  }

  Future<Recipe> createRecipe(Map<String, dynamic> data) async {
    final response = await _api.post('/recipes', body: data);
    return Recipe.fromJson(response['recipe'] as Map<String, dynamic>);
  }

  Future<Recipe> updateRecipe(String id, Map<String, dynamic> data) async {
    final response = await _api.put('/recipes/$id', body: data);
    return Recipe.fromJson(response['recipe'] as Map<String, dynamic>);
  }

  Future<void> deleteRecipe(String id) async {
    await _api.delete('/recipes/$id');
  }

  Future<bool> toggleFavorite(String recipeId) async {
    final response = await _api.post('/recipes/$recipeId/favorite');
    return response['favorited'] == true;
  }
}
