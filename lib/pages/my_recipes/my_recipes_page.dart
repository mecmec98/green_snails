import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recipe_provider.dart';
import '../../models/recipe.dart';
import '../../services/category_service.dart';
import '../recipes/recipe_detail_page.dart';
import 'widgets/create_new_recipe_banner.dart';
import 'widgets/category_selector.dart';
import 'widgets/recipe_card.dart';

IconData _iconFromName(String name) {
  switch (name) {
    case 'wb_sunny':
      return Icons.wb_sunny_outlined;
    case 'wb_cloudy':
      return Icons.wb_cloudy_outlined;
    case 'nights_stay':
      return Icons.nights_stay_outlined;
    case 'cake':
      return Icons.cake_outlined;
    case 'eco':
      return Icons.eco_rounded;
    case 'cookie':
      return Icons.cookie_outlined;
    case 'local_drink':
      return Icons.local_drink_outlined;
    case 'soup_kitchen':
      return Icons.soup_kitchen_outlined;
    default:
      return Icons.grid_view_rounded;
  }
}

//test

class MyRecipesPage extends StatefulWidget {
  const MyRecipesPage({super.key});

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  String? _selectedCategory;
  List<CategoryData> _categories = [];
  bool _loadingCategories = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RecipeProvider>().loadMyRecipes(refresh: true);
      _loadCategories();
    });
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await CategoryService().getCategories();
      if (mounted) {
        setState(() {
          _categories = [
            const CategoryData('All', Icons.grid_view_rounded),
            ...cats.map((c) => CategoryData(c.name, _iconFromName(c.icon))),
          ];
          _loadingCategories = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loadingCategories = false);
      }
    }
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: CreateNewRecipeBanner(
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/create-recipe',
                );
                if (result == true && mounted) {
                  context.read<RecipeProvider>().loadMyRecipes(refresh: true);
                }
              },
            ),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailPage(recipeId: recipe.id),
                            ),
                          );
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
