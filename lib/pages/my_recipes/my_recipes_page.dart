import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recipe_provider.dart';
import '../../models/recipe.dart';
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

  final _categories = [
    CategoryData('All', Icons.grid_view_rounded),
    CategoryData('Favorites', Icons.favorite_rounded),
    CategoryData('Breakfast', Icons.wb_sunny_outlined),
    CategoryData('Lunch', Icons.wb_cloudy_outlined),
    CategoryData('Dinner', Icons.nights_stay_outlined),
    CategoryData('Vegan', Icons.eco_rounded),
    CategoryData('Dessert', Icons.cake_outlined),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RecipeProvider>().loadMyRecipes(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();
    final recipes = recipeProvider.myRecipes;

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
                  '${recipes.length} recipes',
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
            child: recipeProvider.loading && recipes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : recipes.isEmpty
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
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];
                          return RecipeCard(
                            recipe: RecipeCardData(
                              name: recipe.name,
                              time: '${recipe.prepTime ?? 0} min',
                              icon: Icons.menu_book,
                              rating: recipe.ratingAvg,
                            ),
                            isFavorite: false,
                            onFavoriteToggle: () {
                              recipeProvider.toggleFavorite(recipe.id);
                            },
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
