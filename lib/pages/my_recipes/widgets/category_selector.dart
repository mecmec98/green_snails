import 'package:flutter/material.dart';
import '../my_recipes_page.dart';

class CategorySelector extends StatelessWidget {
  final List<CategoryData> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = selectedCategory == category.name ||
            (selectedCategory == null && category.name == 'All');
        return FilterChip(
          selected: isSelected,
          showCheckmark: false,
          avatar: Icon(
            category.icon,
            size: 18,
            color: isSelected
                ? Theme.of(context).colorScheme.onSecondaryContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          label: Text(category.name),
          onSelected: (selected) {
            onCategorySelected(selected ? category.name : null);
          },
        );
      }).toList(),
    );
  }
}
