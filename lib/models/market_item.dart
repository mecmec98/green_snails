class MarketItem {
  final String id;
  final String sellerId;
  final String name;
  final String? description;
  final double price;
  final String unit;
  final double quantity;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? sellerName;
  final String? sellerAvatar;

  MarketItem({
    required this.id,
    required this.sellerId,
    required this.name,
    this.description,
    required this.price,
    required this.unit,
    this.quantity = 1,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.sellerName,
    this.sellerAvatar,
  });

  factory MarketItem.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) {
      if (v == null) return 0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0;
      return 0;
    }

    return MarketItem(
      id: json['id'] ?? '',
      sellerId: json['seller_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: parseDouble(json['price']),
      unit: json['unit'] ?? '',
      quantity: parseDouble(json['quantity']),
      imageUrl: json['image_url'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      sellerName: json['profiles']?['display_name'],
      sellerAvatar: json['profiles']?['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      'price': price,
      'unit': unit,
      'quantity': quantity,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}
