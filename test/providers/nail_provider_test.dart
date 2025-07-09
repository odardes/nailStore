import 'package:flutter_test/flutter_test.dart';
import 'package:nail_store/providers/nail_provider.dart';
import 'package:nail_store/models/nail_design.dart';

void main() {
  group('NailProvider Tests', () {
    late NailProvider provider;

    setUp(() {
      provider = NailProvider();
    });

    group('Initialization', () {
      test('should initialize with correct default values', () {
        expect(provider.selectedCategory, 'All');
        expect(provider.allDesigns, isEmpty);
        expect(provider.favorites, isEmpty);
        expect(provider.userNailDesigns, isEmpty);
        expect(provider.categories.length, 8);
      });

      test('should have valid categories', () {
        final categories = provider.categories;
        
        expect(categories.length, 8);
        expect(categories.any((cat) => cat.name == 'French'), true);
        expect(categories.any((cat) => cat.name == 'Plain'), true);
        expect(categories.any((cat) => cat.name == 'Nail Art'), true);
        expect(categories.any((cat) => cat.name == 'Ombre'), true);
        expect(categories.any((cat) => cat.name == 'Glitter'), true);
        expect(categories.any((cat) => cat.name == 'Pastel'), true);
        expect(categories.any((cat) => cat.name == 'Wedding'), true);
        expect(categories.any((cat) => cat.name == 'Holiday'), true);
      });
    });

    group('Category Management', () {
      test('should change category correctly', () {
        provider.changeCategory('French');
        expect(provider.selectedCategory, 'French');

        provider.changeCategory('Glitter');
        expect(provider.selectedCategory, 'Glitter');

        provider.changeCategory('All');
        expect(provider.selectedCategory, 'All');
      });

      test('should filter designs by category', () {
        // Add test designs
        final testDesigns = [
          NailDesign(
            id: '1',
            title: 'French Manicure',
            imageUrl: 'https://example.com/1.jpg',
            category: 'French',
            colors: ['White', 'Pink'],
            difficulty: 'Easy',
            description: 'Classic french manicure',
            rating: 4.5,
            likes: 100,
          ),
          NailDesign(
            id: '2',
            title: 'Glitter Nails',
            imageUrl: 'https://example.com/2.jpg',
            category: 'Glitter',
            colors: ['Gold', 'Silver'],
            difficulty: 'Medium',
            description: 'Sparkly glitter design',
            rating: 4.8,
            likes: 200,
          ),
          NailDesign(
            id: '3',
            title: 'Another French',
            imageUrl: 'https://example.com/3.jpg',
            category: 'French',
            colors: ['White', 'Nude'],
            difficulty: 'Easy',
            description: 'Another french style',
            rating: 4.2,
            likes: 80,
          ),
        ];

        // Manually set designs for testing
        provider.allDesigns.addAll(testDesigns);

        // Test filtering
        provider.changeCategory('French');
        final frenchDesigns = provider.filteredDesigns;
        expect(frenchDesigns.length, 2);
        expect(frenchDesigns.every((design) => design.category == 'French'), true);

        provider.changeCategory('Glitter');
        final glitterDesigns = provider.filteredDesigns;
        expect(glitterDesigns.length, 1);
        expect(glitterDesigns.first.category, 'Glitter');

        provider.changeCategory('All');
        final allDesigns = provider.filteredDesigns;
        expect(allDesigns.length, 3);
      });
    });

    group('Search Functionality', () {
      test('should search designs by title', () {
        final testDesigns = [
          NailDesign(
            id: '1',
            title: 'Beautiful French Manicure',
            imageUrl: 'https://example.com/1.jpg',
            category: 'French',
            colors: ['White', 'Pink'],
            difficulty: 'Easy',
            description: 'Classic french manicure',
            rating: 4.5,
            likes: 100,
          ),
          NailDesign(
            id: '2',
            title: 'Glitter Party Nails',
            imageUrl: 'https://example.com/2.jpg',
            category: 'Glitter',
            colors: ['Gold', 'Silver'],
            difficulty: 'Medium',
            description: 'Perfect for parties',
            rating: 4.8,
            likes: 200,
          ),
        ];

        provider.allDesigns.addAll(testDesigns);

        final results = provider.searchDesigns('Beautiful');
        expect(results.length, 1);
        expect(results.first.title, 'Beautiful French Manicure');

        final partyResults = provider.searchDesigns('Party');
        expect(partyResults.length, 1);
        expect(partyResults.first.title, 'Glitter Party Nails');
      });

      test('should search designs by description', () {
        final testDesigns = [
          NailDesign(
            id: '1',
            title: 'French Nails',
            imageUrl: 'https://example.com/1.jpg',
            category: 'French',
            colors: ['White', 'Pink'],
            difficulty: 'Easy',
            description: 'Classic french manicure style',
            rating: 4.5,
            likes: 100,
          ),
          NailDesign(
            id: '2',
            title: 'Sparkly Nails',
            imageUrl: 'https://example.com/2.jpg',
            category: 'Glitter',
            colors: ['Gold', 'Silver'],
            difficulty: 'Medium',
            description: 'Perfect for special occasions',
            rating: 4.8,
            likes: 200,
          ),
        ];

        provider.allDesigns.addAll(testDesigns);

        final results = provider.searchDesigns('special occasions');
        expect(results.length, 1);
        expect(results.first.title, 'Sparkly Nails');
      });

      test('should search designs by colors', () {
        final testDesigns = [
          NailDesign(
            id: '1',
            title: 'Red Nails',
            imageUrl: 'https://example.com/1.jpg',
            category: 'Plain',
            colors: ['Red', 'Dark Red'],
            difficulty: 'Easy',
            description: 'Bold red nails',
            rating: 4.5,
            likes: 100,
          ),
          NailDesign(
            id: '2',
            title: 'Blue Nails',
            imageUrl: 'https://example.com/2.jpg',
            category: 'Plain',
            colors: ['Blue', 'Navy'],
            difficulty: 'Easy',
            description: 'Cool blue nails',
            rating: 4.3,
            likes: 120,
          ),
        ];

        provider.allDesigns.addAll(testDesigns);

        final redResults = provider.searchDesigns('Red');
        expect(redResults.length, 1);
        expect(redResults.first.colors.contains('Red'), true);

        final blueResults = provider.searchDesigns('Blue');
        expect(blueResults.length, 1);
        expect(blueResults.first.colors.contains('Blue'), true);
      });

      test('should return empty results for non-matching search', () {
        final testDesigns = [
          NailDesign(
            id: '1',
            title: 'French Manicure',
            imageUrl: 'https://example.com/1.jpg',
            category: 'French',
            colors: ['White', 'Pink'],
            difficulty: 'Easy',
            description: 'Classic french manicure',
            rating: 4.5,
            likes: 100,
          ),
        ];

        provider.allDesigns.addAll(testDesigns);

        final results = provider.searchDesigns('nonexistent');
        expect(results, isEmpty);
      });

      test('should handle empty search query', () {
        final testDesigns = [
          NailDesign(
            id: '1',
            title: 'French Manicure',
            imageUrl: 'https://example.com/1.jpg',
            category: 'French',
            colors: ['White', 'Pink'],
            difficulty: 'Easy',
            description: 'Classic french manicure',
            rating: 4.5,
            likes: 100,
          ),
        ];

        provider.allDesigns.addAll(testDesigns);

        final results = provider.searchDesigns('');
        expect(results.length, 1);
        expect(results, provider.filteredDesigns);
      });
    });

    group('Advanced Search', () {
      test('should filter by multiple categories', () {
        final testDesigns = [
          NailDesign(
            id: '1',
            title: 'French Manicure',
            imageUrl: 'https://example.com/1.jpg',
            category: 'French',
            colors: ['White', 'Pink'],
            difficulty: 'Easy',
            description: 'Classic french manicure',
            rating: 4.5,
            likes: 100,
          ),
          NailDesign(
            id: '2',
            title: 'Glitter Nails',
            imageUrl: 'https://example.com/2.jpg',
            category: 'Glitter',
            colors: ['Gold', 'Silver'],
            difficulty: 'Medium',
            description: 'Sparkly glitter design',
            rating: 4.8,
            likes: 200,
          ),
          NailDesign(
            id: '3',
            title: 'Plain Red',
            imageUrl: 'https://example.com/3.jpg',
            category: 'Plain',
            colors: ['Red'],
            difficulty: 'Easy',
            description: 'Simple red nails',
            rating: 4.0,
            likes: 50,
          ),
        ];

        provider.allDesigns.addAll(testDesigns);

        final results = provider.advancedSearchDesigns(
          categories: ['French', 'Glitter'],
        );

        expect(results.length, 2);
        expect(results.any((design) => design.category == 'French'), true);
        expect(results.any((design) => design.category == 'Glitter'), true);
        expect(results.any((design) => design.category == 'Plain'), false);
      });

      test('should sort by popularity', () {
        final testDesigns = [
          NailDesign(
            id: '1',
            title: 'Less Popular',
            imageUrl: 'https://example.com/1.jpg',
            category: 'French',
            colors: ['White', 'Pink'],
            difficulty: 'Easy',
            description: 'Classic french manicure',
            rating: 4.5,
            likes: 100,
          ),
          NailDesign(
            id: '2',
            title: 'Most Popular',
            imageUrl: 'https://example.com/2.jpg',
            category: 'Glitter',
            colors: ['Gold', 'Silver'],
            difficulty: 'Medium',
            description: 'Sparkly glitter design',
            rating: 4.8,
            likes: 500,
          ),
          NailDesign(
            id: '3',
            title: 'Medium Popular',
            imageUrl: 'https://example.com/3.jpg',
            category: 'Plain',
            colors: ['Red'],
            difficulty: 'Easy',
            description: 'Simple red nails',
            rating: 4.0,
            likes: 300,
          ),
        ];

        provider.allDesigns.addAll(testDesigns);

        final results = provider.advancedSearchDesigns(
          sortBy: 'Most Popular',
        );

        expect(results.length, 3);
        expect(results.first.title, 'Most Popular');
        expect(results.last.title, 'Less Popular');
        expect(results.first.likes > results.last.likes, true);
      });

      test('should sort alphabetically', () {
        final testDesigns = [
          NailDesign(
            id: '1',
            title: 'Zebra Nails',
            imageUrl: 'https://example.com/1.jpg',
            category: 'French',
            colors: ['White', 'Black'],
            difficulty: 'Easy',
            description: 'Zebra pattern nails',
            rating: 4.5,
            likes: 100,
          ),
          NailDesign(
            id: '2',
            title: 'Apple Nails',
            imageUrl: 'https://example.com/2.jpg',
            category: 'Glitter',
            colors: ['Red', 'Green'],
            difficulty: 'Medium',
            description: 'Apple-themed design',
            rating: 4.8,
            likes: 200,
          ),
          NailDesign(
            id: '3',
            title: 'Butterfly Nails',
            imageUrl: 'https://example.com/3.jpg',
            category: 'Plain',
            colors: ['Blue', 'Purple'],
            difficulty: 'Easy',
            description: 'Butterfly pattern',
            rating: 4.0,
            likes: 50,
          ),
        ];

        provider.allDesigns.addAll(testDesigns);

        final results = provider.advancedSearchDesigns(
          sortBy: 'A-Z',
        );

        expect(results.length, 3);
        expect(results.first.title, 'Apple Nails');
        expect(results[1].title, 'Butterfly Nails');
        expect(results.last.title, 'Zebra Nails');
      });
    });

    group('Design Lookup', () {
      test('should find design by ID', () {
        final testDesign = NailDesign(
          id: 'test_id',
          title: 'Test Design',
          imageUrl: 'https://example.com/test.jpg',
          category: 'French',
          colors: ['White', 'Pink'],
          difficulty: 'Easy',
          description: 'Test design',
          rating: 4.5,
          likes: 100,
        );

        provider.allDesigns.add(testDesign);

        final foundDesign = provider.getDesignById('test_id');
        expect(foundDesign, isNotNull);
        expect(foundDesign!.title, 'Test Design');
      });

      test('should return null for non-existent ID', () {
        final foundDesign = provider.getDesignById('non_existent_id');
        expect(foundDesign, isNull);
      });
    });

    group('Computed Properties', () {
      test('should return featured designs with high ratings', () {
        final testDesigns = [
          NailDesign(
            id: '1',
            title: 'High Rated',
            imageUrl: 'https://example.com/1.jpg',
            category: 'French',
            colors: ['White', 'Pink'],
            difficulty: 'Easy',
            description: 'High rated design',
            rating: 4.8,
            likes: 100,
          ),
          NailDesign(
            id: '2',
            title: 'Low Rated',
            imageUrl: 'https://example.com/2.jpg',
            category: 'Glitter',
            colors: ['Gold', 'Silver'],
            difficulty: 'Medium',
            description: 'Low rated design',
            rating: 3.5,
            likes: 200,
          ),
        ];

        provider.allDesigns.addAll(testDesigns);

        final featuredDesigns = provider.featuredDesigns;
        expect(featuredDesigns.length, 1);
        expect(featuredDesigns.first.title, 'High Rated');
      });

      test('should return trending designs with many likes', () {
        final testDesigns = [
          NailDesign(
            id: '1',
            title: 'Trending',
            imageUrl: 'https://example.com/1.jpg',
            category: 'French',
            colors: ['White', 'Pink'],
            difficulty: 'Easy',
            description: 'Trending design',
            rating: 4.5,
            likes: 1500,
          ),
          NailDesign(
            id: '2',
            title: 'Not Trending',
            imageUrl: 'https://example.com/2.jpg',
            category: 'Glitter',
            colors: ['Gold', 'Silver'],
            difficulty: 'Medium',
            description: 'Not trending design',
            rating: 4.8,
            likes: 500,
          ),
        ];

        provider.allDesigns.addAll(testDesigns);

        final trendingDesigns = provider.trendingDesigns;
        expect(trendingDesigns.length, 1);
        expect(trendingDesigns.first.title, 'Trending');
      });
    });
  });
} 