class User {
  final String id;
  final String name;
  final String email;
  final String? profileImagePath;
  final DateTime createdAt;
  final int favoriteCount;
  final int uploadCount;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImagePath,
    required this.createdAt,
    this.favoriteCount = 0,
    this.uploadCount = 0,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImagePath,
    DateTime? createdAt,
    int? favoriteCount,
    int? uploadCount,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      createdAt: createdAt ?? this.createdAt,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      uploadCount: uploadCount ?? this.uploadCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImagePath': profileImagePath,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'favoriteCount': favoriteCount,
      'uploadCount': uploadCount,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImagePath: json['profileImagePath'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      favoriteCount: json['favoriteCount'] ?? 0,
      uploadCount: json['uploadCount'] ?? 0,
    );
  }

  // Helper getters
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  bool get hasProfileImage => profileImagePath != null && profileImagePath!.isNotEmpty;
} 