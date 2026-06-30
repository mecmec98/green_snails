import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recipe_provider.dart';
import '../../models/recipe.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RecipeProvider>().loadRecipes(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: recipeProvider.loading && recipeProvider.recipes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : recipeProvider.recipes.isEmpty
              ? const Center(child: Text('No recipes found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recipeProvider.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipeProvider.recipes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.menu_book),
                        title: Text(recipe.name),
                        subtitle: Text(recipe.authorName ?? 'Unknown'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(recipe.ratingAvg.toStringAsFixed(1)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
