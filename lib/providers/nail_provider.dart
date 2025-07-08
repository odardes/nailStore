import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import '../models/nail_design.dart';
import '../services/unsplash_service.dart';
import 'user_provider.dart';

class NailProvider with ChangeNotifier {
  List<NailDesign> _allDesigns = [];
  List<NailDesign> _favorites = [];
  List<NailCategory> _categories = [];
  List<UserNailDesign> _userNailDesigns = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  
  // UserProvider reference for syncing stats
  UserProvider? _userProvider;

  // SharedPreferences keys
  static const String _favoritesKey = 'favorites';
  static const String _userDesignsKey = 'user_designs';

  // Getters
  List<NailDesign> get allDesigns => _allDesigns;
  List<NailDesign> get favorites => _favorites;
  List<NailCategory> get categories => _categories;
  List<UserNailDesign> get userNailDesigns => _userNailDesigns;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  // Get filtered designs based on selected category
  List<NailDesign> get filteredDesigns {
    if (_selectedCategory == 'All') {
      return _allDesigns;
    }
    return _allDesigns.where((design) => design.category == _selectedCategory).toList();
  }

  // Get featured designs
  List<NailDesign> get featuredDesigns {
    return _allDesigns.where((design) => design.rating >= 4.7).toList();
  }

  // Get trending designs
  List<NailDesign> get trendingDesigns {
    return _allDesigns
        .where((design) => design.likes > 1000)
        .toList()
      ..sort((a, b) => b.likes.compareTo(a.likes));
  }

  NailProvider() {
    _loadData();
  }

  // Set UserProvider reference for syncing stats
  void setUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
    _syncUserStats();
  }

  // Load initial data
  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

        try {
      // Initialize with empty list
      _allDesigns = [];
      _categories = _getCategories(); // Keep categories for navigation
      
      // Load designs from Unsplash API
      final unsplashDesigns = await UnsplashService.fetchRandomDesigns(count: 150);
      if (unsplashDesigns.isNotEmpty) {
        _allDesigns = unsplashDesigns;
      }
      
      // Load favorites from SharedPreferences
      await _loadFavorites();
      
      // Load user designs from SharedPreferences
      await _loadUserDesigns();
    } catch (e) {
      // Error is silently handled to not break user experience
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
      
      _favorites = [];
      for (String favoriteJson in favoritesJson) {
        final favoriteMap = json.decode(favoriteJson) as Map<String, dynamic>;
        
        // Find the design in allDesigns and mark as favorite
        final designIndex = _allDesigns.indexWhere((design) => design.id == favoriteMap['id']);
        if (designIndex != -1) {
          final design = _allDesigns[designIndex];
          final updatedDesign = design.copyWith(isFavorite: true);
          _allDesigns[designIndex] = updatedDesign;
          _favorites.add(updatedDesign);
        }
      }
    } catch (e) {
      // Error loading favorites - use empty list
      _favorites = [];
    }
  }

  // Toggle favorite status
  void toggleFavorite(String designId) {
    final designIndex = _allDesigns.indexWhere((design) => design.id == designId);
    if (designIndex != -1) {
      final design = _allDesigns[designIndex];
      final updatedDesign = design.copyWith(isFavorite: !design.isFavorite);
      _allDesigns[designIndex] = updatedDesign;

      if (updatedDesign.isFavorite) {
        _favorites.add(updatedDesign);
      } else {
        _favorites.removeWhere((fav) => fav.id == designId);
      }

      notifyListeners();
      _saveFavorites();
      _syncUserStats();
    }
  }

  // Save favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = _favorites.map((design) {
        return json.encode({
          'id': design.id,
          'title': design.title,
          'imageUrl': design.imageUrl,
          'category': design.category,
          'colors': design.colors,
          'difficulty': design.difficulty,
          'description': design.description,
          'rating': design.rating,
          'likes': design.likes,
        });
      }).toList();
      
      await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      // Error saving favorites
    }
  }

  // Change selected category
  void changeCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Search designs
  List<NailDesign> searchDesigns(String query) {
    if (query.isEmpty) {
      return filteredDesigns;
    }
    
    return _allDesigns.where((design) {
      final titleLower = design.title.toLowerCase();
      final descriptionLower = design.description.toLowerCase();
      final categoryLower = design.category.toLowerCase();
      final queryLower = query.toLowerCase();
      
      return titleLower.contains(queryLower) ||
             descriptionLower.contains(queryLower) ||
             categoryLower.contains(queryLower) ||
             design.colors.any((color) => color.toLowerCase().contains(queryLower));
    }).toList();
  }

  // Advanced search with filters
  List<NailDesign> advancedSearchDesigns({
    String? searchQuery,
    List<String>? categories,
    List<String>? colors,
    String? sortBy,
  }) {
    List<NailDesign> results = List.from(_allDesigns);
    
    // Apply text search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      results = results.where((design) {
        final titleLower = design.title.toLowerCase();
        final descriptionLower = design.description.toLowerCase();
        final categoryLower = design.category.toLowerCase();
        final queryLower = searchQuery.toLowerCase();
        
        return titleLower.contains(queryLower) ||
               descriptionLower.contains(queryLower) ||
               categoryLower.contains(queryLower) ||
               design.colors.any((color) => color.toLowerCase().contains(queryLower));
      }).toList();
    }
    
    // Apply category filter
    if (categories != null && categories.isNotEmpty) {
      results = results.where((design) {
        return categories.contains(design.category);
      }).toList();
    }
    
    // Apply color filter
    if (colors != null && colors.isNotEmpty) {
      results = results.where((design) {
        return colors.any((filterColor) => 
          design.colors.any((designColor) => 
            designColor.toLowerCase().contains(filterColor.toLowerCase())
          )
        );
      }).toList();
    }
    
    // Apply sorting
    if (sortBy != null) {
      switch (sortBy) {
        case 'Most Popular':
          results.sort((a, b) => b.likes.compareTo(a.likes));
          break;
        case 'Newest':
          // For mock data, we'll sort by ID (higher ID = newer)
          results.sort((a, b) => b.id.compareTo(a.id));
          break;
        case 'Oldest':
          results.sort((a, b) => a.id.compareTo(b.id));
          break;
        case 'A-Z':
          results.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Z-A':
          results.sort((a, b) => b.title.compareTo(a.title));
          break;
      }
    }
    
    return results;
  }

  // Get design by id
  NailDesign? getDesignById(String id) {
    try {
      return _allDesigns.firstWhere((design) => design.id == id);
    } catch (e) {
      return null;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await _loadData();
  }

  // Load designs from Unsplash API
  Future<void> loadFromUnsplash({String? category, int count = 50}) async {
    try {
      List<NailDesign> unsplashDesigns;
      
      if (category != null) {
        unsplashDesigns = await UnsplashService.fetchNailDesigns(
          category: category,
          perPage: count,
        );
      } else {
        unsplashDesigns = await UnsplashService.fetchRandomDesigns(count: count);
      }
      
      if (unsplashDesigns.isNotEmpty) {
        _allDesigns.addAll(unsplashDesigns);
        notifyListeners();
      }
         } catch (e) {
       // Error loading from Unsplash - silently handled
     }
  }

  // User Nail Designs Functions
  
  // Add user design
  Future<void> addUserDesign({
    required String title,
    required String imagePath,
    required String category,
    required List<String> colors,
    required String description,
  }) async {
    final userDesign = UserNailDesign(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      imagePath: imagePath,
      category: category,
      colors: colors,
      description: description,
      createdAt: DateTime.now(),
    );

    _userNailDesigns.add(userDesign);
    notifyListeners();
    await _saveUserDesigns();
    _syncUserStats();
  }

  // Delete user design
  void deleteUserDesign(String designId) {
    final designIndex = _userNailDesigns.indexWhere((design) => design.id == designId);
    if (designIndex != -1) {
      final design = _userNailDesigns[designIndex];
      
      // Delete the image file
      try {
        File(design.imagePath).deleteSync();
                } catch (e) {
        // Error deleting image file
      }
      
      _userNailDesigns.removeAt(designIndex);
      notifyListeners();
      _saveUserDesigns();
      _syncUserStats();
    }
  }

  // Save user designs to SharedPreferences
  Future<void> _saveUserDesigns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDesignsJson = _userNailDesigns.map((design) {
        return json.encode({
          'id': design.id,
          'title': design.title,
          'imagePath': design.imagePath,
          'category': design.category,
          'colors': design.colors,
          'description': design.description,
          'createdAt': design.createdAt.millisecondsSinceEpoch,
        });
      }).toList();
      
      await prefs.setStringList(_userDesignsKey, userDesignsJson);
    } catch (e) {
      // Error saving user designs
    }
  }

  // Load user designs from SharedPreferences
  Future<void> _loadUserDesigns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDesignsJson = prefs.getStringList(_userDesignsKey) ?? [];
      
      _userNailDesigns = [];
      for (String designJson in userDesignsJson) {
        final designMap = json.decode(designJson) as Map<String, dynamic>;
        
        final userDesign = UserNailDesign(
          id: designMap['id'],
          title: designMap['title'],
          imagePath: designMap['imagePath'],
          category: designMap['category'],
          colors: List<String>.from(designMap['colors']),
          description: designMap['description'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(designMap['createdAt']),
        );
        
        _userNailDesigns.add(userDesign);
      }
    } catch (e) {
      // Error loading user designs - use empty list
      _userNailDesigns = [];
    }
  }

  // Get user design by id
  UserNailDesign? getUserDesignById(String id) {
    try {
      return _userNailDesigns.firstWhere((design) => design.id == id);
    } catch (e) {
      return null;
    }
  }

  // Sync user stats with UserProvider
  void _syncUserStats() {
    if (_userProvider != null) {
      _userProvider!.updateUserStats(
        favoriteCount: _favorites.length,
        uploadCount: _userNailDesigns.length,
      );
    }
  }

  // Get categories for navigation
  List<NailCategory> _getCategories() {
    return [
      NailCategory(
        id: '1',
        name: 'French',
        icon: '🎀',
        description: 'Classic french manicure styles',
      ),
      NailCategory(
        id: '2',
        name: 'Plain',
        icon: '💅',
        description: 'Simple solid color nails',
      ),
      NailCategory(
        id: '3',
        name: 'Nail Art',
        icon: '🎨',
        description: 'Creative and artistic nail designs',
      ),
      NailCategory(
        id: '4',
        name: 'Ombre',
        icon: '🌅',
        description: 'Beautiful gradient effects',
      ),
      NailCategory(
        id: '5',
        name: 'Glitter',
        icon: '✨',
        description: 'Sparkling and glamorous designs',
      ),
      NailCategory(
        id: '6',
        name: 'Pastel',
        icon: '🌸',
        description: 'Soft and gentle colors',
      ),
      NailCategory(
        id: '7',
        name: 'Wedding',
        icon: '💍',
        description: 'Elegant bridal nail designs',
      ),
      NailCategory(
        id: '8',
        name: 'Holiday',
        icon: '🎄',
        description: 'Seasonal and festive designs',
      ),
    ];
  }
} 