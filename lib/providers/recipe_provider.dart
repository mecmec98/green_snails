import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeService _recipeService = RecipeService();

  List<Recipe> _recipes = [];
  List<Recipe> _myRecipes = [];
  List<Recipe> _favorites = [];
  bool _loading = false;
  String? _error;
  int _total = 0;
  int _page = 1;
  bool _hasMore = true;

  List<Recipe> get recipes => _recipes;
  List<Recipe> get myRecipes => _myRecipes;
  List<Recipe> get favorites => _favorites;
  bool get loading => _loading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> loadRecipes({bool refresh = false, String? search, String? category}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _recipeService.getRecipes(
        page: _page,
        search: search,
        category: category,
      );

      if (refresh) {
        _recipes = result.recipes;
      } else {
        _recipes.addAll(result.recipes);
      }

      _total = result.total;
      _hasMore = _recipes.length < _total;
      _page++;
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadMyRecipes({bool refresh = false}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _recipeService.getMyRecipes(page: refresh ? 1 : _page);
      if (refresh) {
        _myRecipes = result.recipes;
      } else {
        _myRecipes.addAll(result.recipes);
      }
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadFavorites({bool refresh = false}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _recipeService.getFavorites(page: refresh ? 1 : _page);
      if (refresh) {
        _favorites = result.recipes;
      } else {
        _favorites.addAll(result.recipes);
      }
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<Recipe?> createRecipe(Map<String, dynamic> data) async {
    try {
      final recipe = await _recipeService.createRecipe(data);
      _myRecipes.insert(0, recipe);
      notifyListeners();
      return recipe;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Recipe?> updateRecipe(String id, Map<String, dynamic> data) async {
    try {
      final recipe = await _recipeService.updateRecipe(id, data);
      _updateInList(_recipes, recipe);
      _updateInList(_myRecipes, recipe);
      notifyListeners();
      return recipe;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteRecipe(String id) async {
    try {
      await _recipeService.deleteRecipe(id);
      _recipes.removeWhere((r) => r.id == id);
      _myRecipes.removeWhere((r) => r.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleFavorite(String recipeId) async {
    try {
      final favorited = await _recipeService.toggleFavorite(recipeId);
      if (favorited) {
        final recipe = _recipes.firstWhere((r) => r.id == recipeId);
        _favorites.insert(0, recipe);
      } else {
        _favorites.removeWhere((r) => r.id == recipeId);
      }
      notifyListeners();
      return favorited;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _updateInList(List<Recipe> list, Recipe updated) {
    final index = list.indexWhere((r) => r.id == updated.id);
    if (index != -1) {
      list[index] = updated;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
