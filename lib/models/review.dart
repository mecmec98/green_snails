class Review {
  final String id;
  final String userId;
  final String recipeId;
  final int rating;
  final String? comment;
  final DateTime? createdAt;
  final String? authorName;
  final String? authorAvatar;

  Review({
    required this.id,
    required this.userId,
    required this.recipeId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.authorName,
    this.authorAvatar,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      recipeId: json['recipe_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      authorName: json['profiles']?['display_name'],
      authorAvatar: json['profiles']?['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      if (comment != null) 'comment': comment,
    };
  }
}
