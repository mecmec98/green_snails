class StoreItem {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StoreItem({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) {
      if (v == null) return 0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0;
      return 0;
    }

    return StoreItem(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: parseDouble(json['price']),
      imageUrl: json['image_url'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      'price': price,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}
