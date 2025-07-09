import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nail_design.dart';

class UnsplashService {
  static const String _baseUrl = 'https://api.unsplash.com';
  static const String _accessKey = 'T7n-5tLeNy03e5nE69AWOSV83QjQnQIi4WedvGXcQ6w'; // Buraya API key'inizi yazın
  
  final http.Client _httpClient;
  
  UnsplashService({http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();
  
  // Static instance for backward compatibility
  static final UnsplashService _instance = UnsplashService();
  
  // Nail art search queries
  static const List<String> _nailQueries = [
    'nail art',
    'nail design',
    'manicure',
    'gel nails',
    'acrylic nails',
    'nail polish',
    'french manicure',
    'nail decoration',
    'glitter nails',
    'matte nails',
    'ombre nails',
    'stiletto nails',
  ];
  
  // Category mapping
  static const Map<String, List<String>> _categoryQueries = {
    'French': ['french manicure', 'french nails', 'classic french'],
    'Gel': ['gel nails', 'gel manicure', 'gel polish'],
    'Acrylic': ['acrylic nails', 'acrylic manicure', 'long nails'],
    'Glitter': ['glitter nails', 'sparkle nails', 'glitter manicure'],
    'Matte': ['matte nails', 'matte polish', 'matte manicure'],
    'Ombre': ['ombre nails', 'gradient nails', 'ombre manicure'],
    'Stiletto': ['stiletto nails', 'pointed nails', 'sharp nails'],
    'Short': ['short nails', 'natural nails', 'everyday nails'],
  };
  
  // Static methods for backward compatibility
  static Future<List<NailDesign>> fetchNailDesigns({
    String? category,
    int page = 1,
    int perPage = 30,
  }) async {
    return _instance._fetchNailDesigns(
      category: category,
      page: page,
      perPage: perPage,
    );
  }
  
  static Future<List<NailDesign>> fetchRandomDesigns({int count = 50}) async {
    return _instance._fetchRandomDesigns(count: count);
  }
  
  // Instance methods
  Future<List<NailDesign>> _fetchNailDesigns({
    String? category,
    int page = 1,
    int perPage = 30,
  }) async {
    try {
      String query = _getQueryForCategory(category);
      
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/search/photos?query=$query&page=$page&per_page=$perPage&orientation=portrait'),
        headers: {
          'Authorization': 'Client-ID $_accessKey',
          'Accept-Version': 'v1',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        
        return results.map((photo) => _convertToNailDesign(photo, category)).toList();
      } else {
        throw Exception('Failed to fetch images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching nail designs: $e');
    }
  }
  
  String _getQueryForCategory(String? category) {
    if (category == null) {
      return _nailQueries.first;
    }
    
    if (_categoryQueries.containsKey(category)) {
      final queries = _categoryQueries[category]!;
      return queries.first;
    }
    
    return '$category nails';
  }
  
  NailDesign _convertToNailDesign(Map<String, dynamic> photo, String? category) {
    final urls = photo['urls'];
    final tags = photo['tags'] as List<dynamic>? ?? [];
    
    // Extract colors from tags (simplified)
    final colors = _extractColors(tags);
    
    // Generate description
    final description = _generateDescription(photo, category);
    
    return NailDesign(
      id: photo['id'],
      title: _generateTitle(photo, category),
      description: description,
      imageUrl: urls['regular'],
      category: category ?? 'Genel',
      colors: colors,
      difficulty: _getDifficultyForCategory(category),
      rating: _generateRating(photo),
      likes: photo['likes'] ?? 0,
      isFavorite: false,
    );
  }
  
  String _generateTitle(Map<String, dynamic> photo, String? category) {
    final user = photo['user'];
    final altDescription = photo['alt_description'] as String?;
    
    if (altDescription != null && altDescription.isNotEmpty) {
      return _formatTitle(altDescription);
    }
    
    final categoryName = category ?? 'Nail Art';
    return '$categoryName Design by ${user['name']}';
  }
  
  String _formatTitle(String title) {
    // Clean and format title
    title = title.replaceAll(RegExp(r'[^\w\s]'), '');
    title = title.split(' ').take(6).join(' ');
    return title.length > 50 ? '${title.substring(0, 50)}...' : title;
  }
  
  String _generateDescription(Map<String, dynamic> photo, String? category) {
    final tags = photo['tags'] as List<dynamic>? ?? [];
    final altDescription = photo['alt_description'] as String?;
    
    String description = '';
    
    if (altDescription != null && altDescription.isNotEmpty) {
      description = altDescription;
    } else {
      description = 'Beautiful ${category ?? 'nail art'} design perfect for any occasion.';
    }
    
    // Add tags as additional info
    if (tags.isNotEmpty) {
      final tagTitles = tags.map((tag) => tag['title']).take(3).join(', ');
      description += '\n\nTags: $tagTitles';
    }
    
    return description;
  }
  
  List<String> _extractColors(List<dynamic> tags) {
    final colorKeywords = {
      'red': 'Kırmızı',
      'pink': 'Pembe',
      'blue': 'Mavi',
      'green': 'Yeşil',
      'purple': 'Mor',
      'black': 'Siyah',
      'white': 'Beyaz',
      'gold': 'Altın',
      'silver': 'Gümüş',
      'nude': 'Nude',
      'glitter': 'Sim',
      'matte': 'Mat',
    };
    
    List<String> colors = [];
    
    for (final tag in tags) {
      final tagTitle = tag['title'].toString().toLowerCase();
      for (final entry in colorKeywords.entries) {
        if (tagTitle.contains(entry.key) && !colors.contains(entry.value)) {
          colors.add(entry.value);
        }
      }
    }
    
    // Default colors if none found
    if (colors.isEmpty) {
      colors.addAll(['Pembe', 'Beyaz']);
    }
    
    return colors.take(3).toList();
  }
  
  String _getDifficultyForCategory(String? category) {
    const Map<String, String> difficultyMap = {
      'French': 'Kolay',
      'Gel': 'Orta',
      'Acrylic': 'Zor',
      'Glitter': 'Kolay',
      'Matte': 'Kolay',
      'Ombre': 'Orta',
      'Stiletto': 'Zor',
      'Short': 'Kolay',
    };
    
    return difficultyMap[category] ?? 'Orta';
  }
  
  double _generateRating(Map<String, dynamic> photo) {
    final likes = photo['likes'] as int? ?? 0;
    
    // Convert likes to rating (0-5 scale)
    if (likes > 1000) return 5.0;
    if (likes > 500) return 4.5;
    if (likes > 200) return 4.0;
    if (likes > 100) return 3.5;
    if (likes > 50) return 3.0;
    return 2.5;
  }
  
  // Get random designs from different categories
  Future<List<NailDesign>> _fetchRandomDesigns({int count = 50}) async {
    final List<NailDesign> allDesigns = [];
    
    for (final category in _categoryQueries.keys) {
      try {
        final designs = await _fetchNailDesigns(
          category: category,
          perPage: count ~/ _categoryQueries.length,
        );
        allDesigns.addAll(designs);
      } catch (e) {
        // Silently continue if a category fails
      }
    }
    
    // Shuffle for random order
    allDesigns.shuffle();
    return allDesigns.take(count).toList();
  }
} 