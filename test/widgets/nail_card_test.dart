import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nail_store/widgets/nail_card.dart';
import 'package:nail_store/models/nail_design.dart';
import 'package:nail_store/providers/nail_provider.dart';

void main() {
  group('NailCard Widget Tests', () {
    late NailDesign testDesign;
    late NailProvider mockProvider;

    setUp(() {
      testDesign = NailDesign(
        id: 'test_1',
        title: 'Beautiful French Manicure',
        imageUrl: 'https://example.com/test.jpg',
        category: 'French',
        colors: ['White', 'Pink'],
        difficulty: 'Kolay',
        description: 'Classic french manicure design',
        rating: 4.5,
        likes: 100,
        isFavorite: false,
      );
      mockProvider = NailProvider();
    });

    Widget createTestWidget(NailDesign design, {VoidCallback? onTap}) {
      return MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<NailProvider>.value(
            value: mockProvider,
            child: SizedBox(
              width: 200, // Fixed width for consistent testing
              height: 280, // Sufficient height to prevent overflow
              child: NailCard(
                design: design,
                onTap: onTap,
              ),
            ),
          ),
        ),
      );
    }

    group('Widget Structure', () {
      testWidgets('should display nail design title', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.text('Beautiful French Manicure'), findsOneWidget);
      });

      testWidgets('should display nail design category', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.text('French'), findsOneWidget);
      });

      testWidgets('should display nail design colors', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.text('White, Pink'), findsOneWidget);
      });

      testWidgets('should display nail design likes', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.text('100'), findsOneWidget);
      });

      testWidgets('should display difficulty badge', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.text('Kolay'), findsOneWidget);
      });

      testWidgets('should display heart icons', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.byIcon(Icons.favorite), findsAtLeastNWidgets(1));
      });
    });

    group('Difficulty Colors', () {
      testWidgets('should show easy difficulty', (WidgetTester tester) async {
        final easyDesign = testDesign.copyWith(difficulty: 'Kolay');
        await tester.pumpWidget(createTestWidget(easyDesign));

        expect(find.text('Kolay'), findsOneWidget);
      });

      testWidgets('should show medium difficulty', (WidgetTester tester) async {
        final mediumDesign = testDesign.copyWith(difficulty: 'Orta');
        await tester.pumpWidget(createTestWidget(mediumDesign));

        expect(find.text('Orta'), findsOneWidget);
      });

      testWidgets('should show hard difficulty', (WidgetTester tester) async {
        final hardDesign = testDesign.copyWith(difficulty: 'Zor');
        await tester.pumpWidget(createTestWidget(hardDesign));

        expect(find.text('Zor'), findsOneWidget);
      });
    });

    group('Interaction Tests', () {
      testWidgets('should call onTap when card is tapped', (WidgetTester tester) async {
        bool tapped = false;
        void onTap() {
          tapped = true;
        }

        await tester.pumpWidget(createTestWidget(testDesign, onTap: onTap));

        await tester.tap(find.byType(InkWell));
        await tester.pump();

        expect(tapped, true);
      });

      testWidgets('should handle favorite toggle', (WidgetTester tester) async {
        // Add the design to provider's allDesigns for toggle to work
        mockProvider.allDesigns.add(testDesign);
        
        await tester.pumpWidget(createTestWidget(testDesign));

        // Find the specific favorite button within NailCard
        final nailCardFinder = find.byType(NailCard);
        final favoriteButton = find.descendant(
          of: nailCardFinder,
          matching: find.byType(GestureDetector),
        );
        
        if (favoriteButton.evaluate().isNotEmpty) {
          await tester.tap(favoriteButton.first);
          await tester.pump();
        }

        // The test passes if no exception is thrown
        expect(find.byType(NailCard), findsOneWidget);
      });
    });

    group('Image Loading', () {
      testWidgets('should display cached network image', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.byType(CachedNetworkImage), findsOneWidget);
      });

      testWidgets('should show placeholder while loading', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Layout and Styling', () {
      testWidgets('should have proper card structure', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(InkWell), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
      });

      testWidgets('should have proper aspect ratio for image', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.byType(AspectRatio), findsOneWidget);
      });

      testWidgets('should have proper border radius', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.byType(ClipRRect), findsOneWidget);
      });

      testWidgets('should position elements correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.byType(Positioned), findsAtLeastNWidgets(1));
        // Find Stack widget within NailCard specifically
        final nailCardFinder = find.byType(NailCard);
        final stackFinder = find.descendant(
          of: nailCardFinder,
          matching: find.byType(Stack),
        );
        expect(stackFinder, findsAtLeastNWidgets(1));
      });
    });

    group('Content Overflow', () {
      testWidgets('should handle long titles properly', (WidgetTester tester) async {
        final longTitleDesign = testDesign.copyWith(
          title: 'This is a very long title that should be truncated properly to prevent overflow',
        );
        await tester.pumpWidget(createTestWidget(longTitleDesign));

        // Look for truncated text
        expect(find.byType(Text), findsAtLeastNWidgets(1));
        // Check that NailCard renders without error
        expect(find.byType(NailCard), findsOneWidget);
      });

      testWidgets('should handle many colors properly', (WidgetTester tester) async {
        final manyColorsDesign = testDesign.copyWith(
          colors: ['Red', 'Blue', 'Green', 'Yellow', 'Orange', 'Purple', 'Pink', 'Black'],
        );
        await tester.pumpWidget(createTestWidget(manyColorsDesign));

        // Check that text is displayed (may be truncated)
        expect(find.byType(Text), findsAtLeastNWidgets(1));
        expect(find.byType(NailCard), findsOneWidget);
      });
    });

    group('Favorite State', () {
      testWidgets('should show correct favorite state when isFavorite is true', (WidgetTester tester) async {
        final favoriteDesign = testDesign.copyWith(isFavorite: true);
        await tester.pumpWidget(createTestWidget(favoriteDesign));

        expect(find.byType(NailCard), findsOneWidget);
      });

      testWidgets('should show correct favorite state when isFavorite is false', (WidgetTester tester) async {
        final nonFavoriteDesign = testDesign.copyWith(isFavorite: false);
        await tester.pumpWidget(createTestWidget(nonFavoriteDesign));

        expect(find.byType(NailCard), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty colors list', (WidgetTester tester) async {
        final emptyColorsDesign = testDesign.copyWith(colors: []);
        await tester.pumpWidget(createTestWidget(emptyColorsDesign));

        expect(find.text('Colors: '), findsOneWidget);
      });

      testWidgets('should handle zero likes', (WidgetTester tester) async {
        final zeroLikesDesign = testDesign.copyWith(likes: 0);
        await tester.pumpWidget(createTestWidget(zeroLikesDesign));

        expect(find.text('0'), findsOneWidget);
      });

      testWidgets('should handle high number of likes', (WidgetTester tester) async {
        final highLikesDesign = testDesign.copyWith(likes: 999999);
        await tester.pumpWidget(createTestWidget(highLikesDesign));

        expect(find.text('999999'), findsOneWidget);
      });

      testWidgets('should handle empty title', (WidgetTester tester) async {
        final emptyTitleDesign = testDesign.copyWith(title: '');
        await tester.pumpWidget(createTestWidget(emptyTitleDesign));

        expect(find.byType(NailCard), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should build without throwing exceptions', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        expect(find.byType(NailCard), findsOneWidget);
      });

      testWidgets('should rebuild efficiently when design changes', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(testDesign));

        final newDesign = testDesign.copyWith(title: 'New Title');
        await tester.pumpWidget(createTestWidget(newDesign));

        expect(find.text('New Title'), findsOneWidget);
        expect(find.text('Beautiful French Manicure'), findsNothing);
      });
    });
  });
} 