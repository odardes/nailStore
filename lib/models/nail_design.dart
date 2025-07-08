class NailDesign {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final List<String> colors;
  final String difficulty;
  final String description;
  final bool isFavorite;
  final double rating;
  final int likes;

  NailDesign({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.colors,
    required this.difficulty,
    required this.description,
    this.isFavorite = false,
    required this.rating,
    required this.likes,
  });

  NailDesign copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? category,
    List<String>? colors,
    String? difficulty,
    String? description,
    bool? isFavorite,
    double? rating,
    int? likes,
  }) {
    return NailDesign(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      colors: colors ?? this.colors,
      difficulty: difficulty ?? this.difficulty,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      likes: likes ?? this.likes,
    );
  }
}

class NailCategory {
  final String id;
  final String name;
  final String icon;
  final String description;

  NailCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}

// User uploaded nail design
class UserNailDesign {
  final String id;
  final String title;
  final String imagePath; // Local file path
  final String category;
  final List<String> colors;
  final String description;
  final DateTime createdAt;

  UserNailDesign({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.category,
    required this.colors,
    required this.description,
    required this.createdAt,
  });

  UserNailDesign copyWith({
    String? id,
    String? title,
    String? imagePath,
    String? category,
    List<String>? colors,
    String? description,
    DateTime? createdAt,
  }) {
    return UserNailDesign(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      colors: colors ?? this.colors,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 