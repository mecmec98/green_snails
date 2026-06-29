import 'package:flutter/material.dart';
import 'widgets/create_new_recipe_banner.dart';
import 'widgets/category_selector.dart';
import 'widgets/recipe_card.dart';

class MyRecipesPage extends StatefulWidget {
  const MyRecipesPage({super.key});

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  String? _selectedCategory;
  final _favorites = <String>{};

  final _categories = [
    CategoryData('All', Icons.grid_view_rounded),
    CategoryData('Favorites', Icons.favorite_rounded),
    CategoryData('Breakfast', Icons.wb_sunny_outlined),
    CategoryData('Lunch', Icons.wb_cloudy_outlined),
    CategoryData('Dinner', Icons.nights_stay_outlined),
    CategoryData('Vegan', Icons.eco_rounded),
    CategoryData('Dessert', Icons.cake_outlined),
  ];

  final _recipes = [
    RecipeData('Avocado Toast', ['Breakfast'], '15 min', Icons.breakfast_dining, 4.5),
    RecipeData('Berry Smoothie Bowl', ['Breakfast', 'Vegan'], '10 min', Icons.blender, 4.8),
    RecipeData('Pancakes', ['Breakfast', 'Dessert'], '20 min', Icons.breakfast_dining, 4.2),
    RecipeData('Caesar Salad', ['Lunch'], '15 min', Icons.lunch_dining, 4.0),
    RecipeData('Grilled Chicken Wrap', ['Lunch'], '25 min', Icons.kebab_dining, 4.6),
    RecipeData('Tomato Soup', ['Lunch', 'Vegan'], '30 min', Icons.soup_kitchen, 3.9),
    RecipeData('Grilled Salmon', ['Dinner'], '35 min', Icons.set_meal, 4.7),
    RecipeData('Beef Steak', ['Dinner'], '25 min', Icons.dinner_dining, 4.3),
    RecipeData('Pasta Carbonara', ['Dinner'], '20 min', Icons.ramen_dining, 4.4),
    RecipeData('Vegan Buddha Bowl', ['Vegan', 'Lunch'], '20 min', Icons.eco, 4.1),
    RecipeData('Tofu Stir Fry', ['Vegan', 'Dinner'], '25 min', Icons.egg_alt, 3.8),
    RecipeData('Chickpea Curry', ['Vegan', 'Dinner'], '30 min', Icons.rice_bowl, 4.5),
    RecipeData('Chocolate Lava Cake', ['Dessert'], '25 min', Icons.cake, 4.9),
    RecipeData('Tiramisu', ['Dessert'], '30 min', Icons.icecream, 4.6),
    RecipeData('Fruit Tart', ['Dessert', 'Vegan'], '40 min', Icons.bakery_dining, 4.3),
  ];

  List<RecipeData> get _filteredRecipes {
    if (_selectedCategory == null || _selectedCategory == 'All') {
      return _recipes;
    }
    if (_selectedCategory == 'Favorites') {
      return _recipes.where((r) => _favorites.contains(r.name)).toList();
    }
    return _recipes.where((r) => r.categories.contains(_selectedCategory)).toList();
  }

  void _toggleFavorite(String recipeName) {
    setState(() {
      if (_favorites.contains(recipeName)) {
        _favorites.remove(recipeName);
      } else {
        _favorites.add(recipeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRecipes;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'My Recipes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: CreateNewRecipeBanner(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  '${filtered.length} recipes',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.filter_list,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CategorySelector(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No recipes found',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final recipe = filtered[index];
                      return RecipeCard(
                        recipe: recipe,
                        isFavorite: _favorites.contains(recipe.name),
                        onFavoriteToggle: () => _toggleFavorite(recipe.name),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CategoryData {
  final String name;
  final IconData icon;

  const CategoryData(this.name, this.icon);
}

class RecipeData {
  final String name;
  final List<String> categories;
  final String time;
  final IconData icon;
  final double rating;

  const RecipeData(this.name, this.categories, this.time, this.icon, this.rating);
}
