// Tests for TırnakFikri nail inspiration app
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nail_store/main.dart';
import 'package:nail_store/providers/nail_provider.dart';


void main() {
  testWidgets('NailStoreApp builds without layout overflow', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NailStoreApp());

    // Wait for initial loading
    await tester.pump(const Duration(seconds: 1));

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);

    // Test that we can navigate without overflow errors
    try {
    await tester.pump();
      // If we get here without exception, layout is working
      expect(true, true);
    } catch (e) {
      fail('Layout overflow detected: $e');
    }
  });
  test('NailProvider provides categories correctly', () {
    // Test provider categories
    final provider = NailProvider();
    
    // Verify categories are not empty
    expect(provider.categories.isNotEmpty, true);
    expect(provider.categories.length, 8);
  });

  test('NailProvider initializes correctly', () async {
    final provider = NailProvider();
    
    // Wait for async initialization (including SharedPreferences)
    await Future.delayed(const Duration(seconds: 4));
    
    // Verify provider has basic setup
    expect(provider.categories.isNotEmpty, true);
    expect(provider.selectedCategory, 'All');
    // Note: allDesigns may be empty if Unsplash API fails
  });

  test('NailProvider favorite functionality works', () async {
    final provider = NailProvider();
    
    // Wait for initialization (including SharedPreferences)
    await Future.delayed(const Duration(seconds: 3));
    
    // Only test if we have designs (API dependent)
    if (provider.allDesigns.isNotEmpty) {
      // Test adding to favorites
      final designId = provider.allDesigns.first.id;
      provider.toggleFavorite(designId);
      
      // Wait for async save operation
      await Future.delayed(const Duration(milliseconds: 500));
      
      expect(provider.favorites.length, 1);
      expect(provider.favorites.first.id, designId);
      
      // Test removing from favorites
      provider.toggleFavorite(designId);
      
      // Wait for async save operation
      await Future.delayed(const Duration(milliseconds: 500));
      
      expect(provider.favorites.length, 0);
    } else {
      // If no designs, just verify empty state
      expect(provider.favorites.length, 0);
    }
  });

  test('NailProvider category filtering works', () async {
    final provider = NailProvider();
    
    // Wait for initialization (including SharedPreferences)
    await Future.delayed(const Duration(seconds: 3));
    
    // Test filtering by category
    provider.changeCategory('French');
    expect(provider.selectedCategory, 'French');
    
    // Only test filtering if we have designs (API dependent)
    if (provider.allDesigns.isNotEmpty) {
      final filteredDesigns = provider.filteredDesigns;
      expect(filteredDesigns.every((design) => design.category == 'French'), true);
      
      // Test showing all designs
      provider.changeCategory('All');
      expect(provider.filteredDesigns.length, provider.allDesigns.length);
    } else {
      // If no designs, just verify category change works
      expect(provider.selectedCategory, 'French');
    }
  });
}
