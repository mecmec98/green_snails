double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

class Category {
  final int id;
  final String name;
  final String icon;

  Category({required this.id, required this.name, required this.icon});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class Recipe {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final List<Map<String, dynamic>> ingredients;
  final List<Map<String, dynamic>> instructions;
  final int? prepTime;
  final int? cookTime;
  final int? servings;
  final String? imageUrl;
  final bool isPublic;
  final double ratingAvg;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? authorName;
  final String? authorAvatar;
  final List<Category> categories;

  Recipe({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.ingredients = const [],
    this.instructions = const [],
    this.prepTime,
    this.cookTime,
    this.servings,
    this.imageUrl,
    this.isPublic = true,
    this.ratingAvg = 0,
    this.createdAt,
    this.updatedAt,
    this.authorName,
    this.authorAvatar,
    this.categories = const [],
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<Category> cats = [];
    if (json['recipe_categories'] != null) {
      for (final rc in json['recipe_categories']) {
        if (rc['categories'] != null) {
          cats.add(Category.fromJson(rc['categories']));
        }
      }
    }

    return Recipe(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      ingredients: json['ingredients'] is List
          ? (json['ingredients'] as List).cast<Map<String, dynamic>>()
          : [],
      instructions: json['instructions'] is List
          ? (json['instructions'] as List).cast<Map<String, dynamic>>()
          : [],
      prepTime: json['prep_time'] != null ? _toInt(json['prep_time']) : null,
      cookTime: json['cook_time'] != null ? _toInt(json['cook_time']) : null,
      servings: json['servings'] != null ? _toInt(json['servings']) : null,
      imageUrl: json['image_url'],
      isPublic: json['is_public'] ?? true,
      ratingAvg: _toDouble(json['rating_avg']),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      authorName: json['profiles']?['display_name'],
      authorAvatar: json['profiles']?['avatar_url'],
      categories: cats,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      if (prepTime != null) 'prep_time': prepTime,
      if (cookTime != null) 'cook_time': cookTime,
      if (servings != null) 'servings': servings,
      if (imageUrl != null) 'image_url': imageUrl,
      'is_public': isPublic,
      'category_ids': categories.map((c) => c.id).toList(),
    };
  }
}
