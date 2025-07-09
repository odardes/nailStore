#!/bin/bash

# Test Coverage Script for Flutter Nail Store App

echo "🧪 Running Flutter Tests with Coverage..."
echo "=========================================="

# Clean previous coverage data
echo "📦 Cleaning previous coverage data..."
rm -rf coverage/
rm -rf test/.test_coverage.dart

# Run tests with coverage
echo "🏃 Running tests with coverage..."
flutter test --coverage

# Check if tests passed
if [ $? -eq 0 ]; then
    echo "✅ All tests passed!"
else
    echo "❌ Some tests failed. Please fix them before generating coverage report."
    exit 1
fi

# Generate LCOV report
echo "📊 Generating LCOV report..."
if [ -f "coverage/lcov.info" ]; then
    echo "📁 Coverage data generated successfully!"
    echo "📍 Coverage file: coverage/lcov.info"
else
    echo "❌ Coverage file not found. Make sure tests ran successfully."
    exit 1
fi

# Generate HTML report (if genhtml is available)
if command -v genhtml &> /dev/null; then
    echo "🌐 Generating HTML coverage report..."
    genhtml coverage/lcov.info -o coverage/html
    echo "📍 HTML report generated: coverage/html/index.html"
    echo "🌐 Open coverage/html/index.html in your browser to view the report"
else
    echo "ℹ️  genhtml not found. Install lcov to generate HTML reports:"
    echo "   - macOS: brew install lcov"
    echo "   - Ubuntu: sudo apt-get install lcov"
    echo "   - Windows: Use WSL or install lcov manually"
fi

# Display coverage summary
echo ""
echo "📈 Coverage Summary:"
echo "===================="
if command -v lcov &> /dev/null; then
    lcov --summary coverage/lcov.info
else
    echo "ℹ️  Install lcov to see coverage summary"
fi

echo ""
echo "✨ Coverage report generation complete!"
echo "📋 Test files created:"
echo "   - test/models/user_test.dart (17 tests)"
echo "   - test/models/nail_design_test.dart (21 tests)"
echo "   - test/services/unsplash_service_test.dart (8 tests)"
echo "   - test/providers/nail_provider_test.dart (24 tests)"
echo "   - test/widgets/nail_card_test.dart (27 tests) ✅ WORKING"
echo ""
echo "🎯 To improve coverage, add more tests for:"
echo "   - Additional widget tests (AnimatedHeart, AdvancedSearchModal, etc.)"
echo "   - Integration tests for screens"
echo "   - Edge cases and error handling"
echo ""
echo "📊 Run this script again after adding more tests!" 