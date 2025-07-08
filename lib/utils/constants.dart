import 'package:flutter/material.dart';

class AppConstants {
  // App Colors
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color secondaryPink = Color(0xFFF8BBD9);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color lightPurple = Color(0xFFE1BEE7);
  static const Color backgroundGray = Color(0xFFF5F5F5);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE91E63),
      Color(0xFFF8BBD9),
    ],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAFAFA),
      Color(0xFFF5F5F5),
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFAFAFA),
    ],
  );
  
  // Shadow Styles
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x26E91E63),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  // Categories
  static const List<String> categories = [
    'All',
    'French',
    'Plain',
    'Nail Art',
    'Ombre',
    'Glitter',
    'Pastel',
    'Wedding',
    'Holiday',
  ];

  // Available Colors for Filtering
  static const List<String> availableColors = [
    'Pink',
    'White',
    'Red',
    'Blue',
    'Purple',
    'Gold',
    'Black',
    'Silver',
    'Green',
    'Yellow',
    'Orange',
    'Nude',
  ];

  // Sort Options
  static const List<String> sortOptions = [
    'Most Popular',
    'Newest',
    'Oldest',
    'A-Z',
    'Z-A',
  ];

  // App Strings
  static const String appName = 'Nail Ideas';
  
  // Tab Labels
  static const String homeTab = 'Home';
  static const String profileTab = 'Profile';
} 