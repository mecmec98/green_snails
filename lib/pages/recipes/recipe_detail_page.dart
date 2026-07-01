import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../../models/review.dart';
import '../../services/recipe_service.dart';
import '../../services/review_service.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeId;

  const RecipeDetailPage({super.key, required this.recipeId});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  Recipe? _recipe;
  List<Review> _reviews = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final recipe = await RecipeService().getRecipe(widget.recipeId);
      final reviews = await ReviewService().getReviews(widget.recipeId);
      if (mounted) {
        setState(() {
          _recipe = recipe;
          _reviews = reviews;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _addReview() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated) return;

    final rating = await showDialog<int>(
      context: context,
      builder: (ctx) => _RatingDialog(),
    );
    if (rating == null || !mounted) return;

    final commentController = TextEditingController();
    final comment = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add a comment'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: 'Optional comment...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Skip'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, commentController.text),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
    commentController.dispose();
    if (!mounted) return;

    try {
      final review = await ReviewService().createReview(
        widget.recipeId,
        rating,
        comment != null && comment.trim().isNotEmpty ? comment.trim() : null,
      );
      if (mounted) {
        setState(() => _reviews.insert(0, review));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _recipe == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(child: Text(_error ?? 'Recipe not found')),
      );
    }

    final recipe = _recipe!;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(Icons.person, color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.authorName ?? 'Unknown',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          recipe.ratingAvg.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (recipe.description != null && recipe.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              recipe.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              if (recipe.prepTime != null) _InfoChip(Icons.timer_outlined, 'Prep: ${recipe.prepTime} min'),
              if (recipe.cookTime != null) _InfoChip(Icons.whatshot, 'Cook: ${recipe.cookTime} min'),
              if (recipe.servings != null) _InfoChip(Icons.people_outline, '${recipe.servings} servings'),
            ].expand((w) => [w, const SizedBox(width: 8)]).toList()
              ..removeLast(),
          ),
          if (recipe.categories.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: recipe.categories.map((c) => Chip(label: Text(c.name))).toList(),
            ),
          ],
          const SizedBox(height: 24),
          Text('Ingredients', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...recipe.ingredients.map((i) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 6),
                const SizedBox(width: 8),
                Text(
                  '${i['quantity'] ?? ''} ${i['unit'] ?? ''} ${i['name'] ?? ''}'.trim(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )),
          const SizedBox(height: 24),
          Text('Instructions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...recipe.instructions.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value['step'] ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 24),
          Row(
            children: [
              Text('Reviews (${_reviews.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton.icon(
                onPressed: _addReview,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Review'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_reviews.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No reviews yet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            ..._reviews.map((review) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(Icons.person, size: 16, color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          review.authorName ?? 'User',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Row(
                          children: List.generate(5, (i) => Icon(
                            i < review.rating ? Icons.star : Icons.star_border,
                            size: 14,
                            color: Colors.amber,
                          )),
                        ),
                      ],
                    ),
                    if (review.comment != null && review.comment!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(review.comment!, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
            )),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _RatingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rate this recipe'),
      content: StatefulBuilder(
        builder: (context, setState) {
          int rating = 0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) => IconButton(
              icon: Icon(
                i < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 36,
              ),
              onPressed: () {
                rating = i + 1;
                Navigator.pop(context, rating);
              },
            )),
          );
        },
      ),
    );
  }
}
