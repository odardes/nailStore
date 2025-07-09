import 'package:flutter_test/flutter_test.dart';
import 'package:nail_store/models/nail_design.dart';

void main() {
  group('NailDesign Model Tests', () {
    late NailDesign testDesign;

    setUp(() {
      testDesign = NailDesign(
        id: 'test_id',
        title: 'Beautiful French Nails',
        imageUrl: 'https://example.com/image.jpg',
        category: 'French',
        colors: ['#FFFFFF', '#FF6B6B', '#4ECDC4'],
        difficulty: 'Easy',
        description: 'Classic French manicure with modern twist',
        isFavorite: false,
        rating: 4.5,
        likes: 150,
      );
    });

    test('should create NailDesign with all parameters', () {
      expect(testDesign.id, 'test_id');
      expect(testDesign.title, 'Beautiful French Nails');
      expect(testDesign.imageUrl, 'https://example.com/image.jpg');
      expect(testDesign.category, 'French');
      expect(testDesign.colors, ['#FFFFFF', '#FF6B6B', '#4ECDC4']);
      expect(testDesign.difficulty, 'Easy');
      expect(testDesign.description, 'Classic French manicure with modern twist');
      expect(testDesign.isFavorite, false);
      expect(testDesign.rating, 4.5);
      expect(testDesign.likes, 150);
    });

    test('should create NailDesign with default isFavorite value', () {
      final design = NailDesign(
        id: 'test_id',
        title: 'Test Design',
        imageUrl: 'https://example.com/image.jpg',
        category: 'French',
        colors: ['#FFFFFF'],
        difficulty: 'Easy',
        description: 'Test description',
        rating: 4.0,
        likes: 100,
      );

      expect(design.isFavorite, false);
    });

    group('copyWith method', () {
      test('should return same design when no parameters provided', () {
        final copiedDesign = testDesign.copyWith();
        
        expect(copiedDesign.id, testDesign.id);
        expect(copiedDesign.title, testDesign.title);
        expect(copiedDesign.imageUrl, testDesign.imageUrl);
        expect(copiedDesign.category, testDesign.category);
        expect(copiedDesign.colors, testDesign.colors);
        expect(copiedDesign.difficulty, testDesign.difficulty);
        expect(copiedDesign.description, testDesign.description);
        expect(copiedDesign.isFavorite, testDesign.isFavorite);
        expect(copiedDesign.rating, testDesign.rating);
        expect(copiedDesign.likes, testDesign.likes);
      });

      test('should update only provided parameters', () {
        final copiedDesign = testDesign.copyWith(
          title: 'Updated Title',
          isFavorite: true,
          likes: 200,
        );

        expect(copiedDesign.title, 'Updated Title');
        expect(copiedDesign.isFavorite, true);
        expect(copiedDesign.likes, 200);
        expect(copiedDesign.id, testDesign.id);
        expect(copiedDesign.category, testDesign.category);
        expect(copiedDesign.rating, testDesign.rating);
      });

      test('should handle empty colors list', () {
        final copiedDesign = testDesign.copyWith(colors: []);
        expect(copiedDesign.colors, []);
      });
    });
  });

  group('NailCategory Model Tests', () {
    late NailCategory testCategory;

    setUp(() {
      testCategory = NailCategory(
        id: 'cat_id',
        name: 'French',
        icon: 'french_icon',
        description: 'Classic French manicure styles',
      );
    });

    test('should create NailCategory with all parameters', () {
      expect(testCategory.id, 'cat_id');
      expect(testCategory.name, 'French');
      expect(testCategory.icon, 'french_icon');
      expect(testCategory.description, 'Classic French manicure styles');
    });
  });

  group('UserNailDesign Model Tests', () {
    late UserNailDesign testUserDesign;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime(2024, 1, 1);
      testUserDesign = UserNailDesign(
        id: 'user_design_id',
        title: 'My Custom Design',
        imagePath: '/path/to/local/image.jpg',
        category: 'Custom',
        colors: ['#FF0000', '#00FF00'],
        description: 'My personal nail design',
        createdAt: testDate,
      );
    });

    test('should create UserNailDesign with all parameters', () {
      expect(testUserDesign.id, 'user_design_id');
      expect(testUserDesign.title, 'My Custom Design');
      expect(testUserDesign.imagePath, '/path/to/local/image.jpg');
      expect(testUserDesign.category, 'Custom');
      expect(testUserDesign.colors, ['#FF0000', '#00FF00']);
      expect(testUserDesign.description, 'My personal nail design');
      expect(testUserDesign.createdAt, testDate);
    });

    group('copyWith method', () {
      test('should return same design when no parameters provided', () {
        final copiedDesign = testUserDesign.copyWith();
        
        expect(copiedDesign.id, testUserDesign.id);
        expect(copiedDesign.title, testUserDesign.title);
        expect(copiedDesign.imagePath, testUserDesign.imagePath);
        expect(copiedDesign.category, testUserDesign.category);
        expect(copiedDesign.colors, testUserDesign.colors);
        expect(copiedDesign.description, testUserDesign.description);
        expect(copiedDesign.createdAt, testUserDesign.createdAt);
      });

      test('should update only provided parameters', () {
        final newDate = DateTime(2024, 2, 1);
        final copiedDesign = testUserDesign.copyWith(
          title: 'Updated Custom Design',
          category: 'Gradient',
          createdAt: newDate,
        );

        expect(copiedDesign.title, 'Updated Custom Design');
        expect(copiedDesign.category, 'Gradient');
        expect(copiedDesign.createdAt, newDate);
        expect(copiedDesign.id, testUserDesign.id);
        expect(copiedDesign.imagePath, testUserDesign.imagePath);
        expect(copiedDesign.description, testUserDesign.description);
      });

      test('should handle empty colors list', () {
        final copiedDesign = testUserDesign.copyWith(colors: []);
        expect(copiedDesign.colors, []);
      });
    });
  });

  group('Edge Cases', () {
    test('should handle empty strings in NailDesign', () {
      final design = NailDesign(
        id: '',
        title: '',
        imageUrl: '',
        category: '',
        colors: [],
        difficulty: '',
        description: '',
        rating: 0.0,
        likes: 0,
      );

      expect(design.id, '');
      expect(design.title, '');
      expect(design.colors, []);
      expect(design.rating, 0.0);
      expect(design.likes, 0);
    });

    test('should handle special characters in titles', () {
      final design = NailDesign(
        id: 'test_id',
        title: 'Nail Art: "Sparkle & Shine" ✨',
        imageUrl: 'https://example.com/image.jpg',
        category: 'Glitter',
        colors: ['#FFD700'],
        difficulty: 'Medium',
        description: 'Sparkly nails with emoji ✨💅',
        rating: 5.0,
        likes: 999,
      );

      expect(design.title, 'Nail Art: "Sparkle & Shine" ✨');
      expect(design.description, 'Sparkly nails with emoji ✨💅');
    });

    test('should handle maximum values', () {
      final design = NailDesign(
        id: 'test_id',
        title: 'Test Design',
        imageUrl: 'https://example.com/image.jpg',
        category: 'Test',
        colors: ['#FFFFFF'],
        difficulty: 'Hard',
        description: 'Test description',
        rating: 5.0,
        likes: 999999,
      );

      expect(design.rating, 5.0);
      expect(design.likes, 999999);
    });
  });
} 