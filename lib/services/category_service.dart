import '../models/recipe.dart';
import 'api_client.dart';

class CategoryService {
  final ApiClient _api = ApiClient();

  Future<List<Category>> getCategories() async {
    final response = await _api.get('/categories');
    return (response['categories'] as List)
        .map((c) => Category.fromJson(c as Map<String, dynamic>))
        .toList();
  }
}
