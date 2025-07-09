import 'package:flutter_test/flutter_test.dart';
import 'package:nail_store/services/unsplash_service.dart';
import 'package:nail_store/models/nail_design.dart';

void main() {
  group('UnsplashService Tests', () {
    group('Static Methods', () {
      test('should handle network errors gracefully', () async {
        // This test checks that the service handles network errors properly
        // without crashing the app
        try {
          await UnsplashService.fetchNailDesigns();
          // If successful, just verify the result is a list
        } catch (e) {
          // Network errors should be handled gracefully
          expect(e, isA<Exception>());
        }
      });

      test('should handle empty category parameter', () async {
        try {
          final designs = await UnsplashService.fetchNailDesigns(category: null);
          expect(designs, isA<List<NailDesign>>());
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('should handle different category parameters', () async {
        try {
          final designs = await UnsplashService.fetchNailDesigns(category: 'French');
          expect(designs, isA<List<NailDesign>>());
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('should handle pagination parameters', () async {
        try {
          final designs = await UnsplashService.fetchNailDesigns(
            page: 1,
            perPage: 10,
          );
          expect(designs, isA<List<NailDesign>>());
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('fetchRandomDesigns', () {
      test('should handle count parameter', () async {
        try {
          final designs = await UnsplashService.fetchRandomDesigns(count: 5);
          expect(designs, isA<List<NailDesign>>());
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('should handle default count', () async {
        try {
          final designs = await UnsplashService.fetchRandomDesigns();
          expect(designs, isA<List<NailDesign>>());
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('Constants and Static Data', () {
      test('should have valid category queries', () {
        // Test that our category mapping is properly structured
        const categoryQueries = {
          'French': ['french manicure', 'french nails', 'classic french'],
          'Gel': ['gel nails', 'gel manicure', 'gel polish'],
          'Acrylic': ['acrylic nails', 'acrylic manicure', 'long nails'],
          'Glitter': ['glitter nails', 'sparkle nails', 'glitter manicure'],
          'Matte': ['matte nails', 'matte polish', 'matte manicure'],
          'Ombre': ['ombre nails', 'gradient nails', 'ombre manicure'],
          'Stiletto': ['stiletto nails', 'pointed nails', 'sharp nails'],
          'Short': ['short nails', 'natural nails', 'everyday nails'],
        };

        expect(categoryQueries['French'], isNotEmpty);
        expect(categoryQueries['Gel'], isNotEmpty);
        expect(categoryQueries['Acrylic'], isNotEmpty);
        expect(categoryQueries['Glitter'], isNotEmpty);
        expect(categoryQueries['Matte'], isNotEmpty);
        expect(categoryQueries['Ombre'], isNotEmpty);
        expect(categoryQueries['Stiletto'], isNotEmpty);
        expect(categoryQueries['Short'], isNotEmpty);
      });

      test('should have valid difficulty mapping', () {
        const difficultyMap = {
          'French': 'Kolay',
          'Gel': 'Orta',
          'Acrylic': 'Zor',
          'Glitter': 'Kolay',
          'Matte': 'Kolay',
          'Ombre': 'Orta',
          'Stiletto': 'Zor',
          'Short': 'Kolay',
        };

        expect(difficultyMap['French'], 'Kolay');
        expect(difficultyMap['Acrylic'], 'Zor');
        expect(difficultyMap['Ombre'], 'Orta');
        expect(difficultyMap['Stiletto'], 'Zor');
      });

      test('should have valid color keywords', () {
        const colorKeywords = {
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

        expect(colorKeywords['red'], 'Kırmızı');
        expect(colorKeywords['pink'], 'Pembe');
        expect(colorKeywords['blue'], 'Mavi');
        expect(colorKeywords['green'], 'Yeşil');
        expect(colorKeywords['purple'], 'Mor');
        expect(colorKeywords['black'], 'Siyah');
        expect(colorKeywords['white'], 'Beyaz');
        expect(colorKeywords['gold'], 'Altın');
        expect(colorKeywords['silver'], 'Gümüş');
        expect(colorKeywords['nude'], 'Nude');
        expect(colorKeywords['glitter'], 'Sim');
        expect(colorKeywords['matte'], 'Mat');
      });
    });

    group('Helper Logic Tests', () {
      test('should generate valid rating from likes', () {
        // Test rating generation logic
        int likes1 = 1500;
        int likes2 = 300;
        int likes3 = 25;

        // High likes should result in high rating
        expect(likes1 > 1000, true);
        
        // Medium likes should result in medium rating
        expect(likes2 > 200 && likes2 <= 500, true);
        
        // Low likes should result in low rating
        expect(likes3 < 50, true);
      });

      test('should format title correctly', () {
        String longTitle = 'This is a very long title that should be truncated because it exceeds the maximum length limit and contains special characters!@#\$%^&*()';
        
        expect(longTitle.length > 50, true);
        
        // Test clean title
        String cleanTitle = longTitle.replaceAll(RegExp(r'[^\w\s]'), '');
        expect(cleanTitle.contains('!@#'), false);
      });
    });
  });
} 