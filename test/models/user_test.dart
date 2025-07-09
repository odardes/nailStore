import 'package:flutter_test/flutter_test.dart';
import 'package:nail_store/models/user.dart';

void main() {
  group('User Model Tests', () {
    late User testUser;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime(2024, 1, 1);
      testUser = User(
        id: 'test_id',
        name: 'John Doe',
        email: 'john@example.com',
        profileImagePath: '/path/to/image.jpg',
        createdAt: testDate,
        favoriteCount: 5,
        uploadCount: 3,
      );
    });

    test('should create User with all parameters', () {
      expect(testUser.id, 'test_id');
      expect(testUser.name, 'John Doe');
      expect(testUser.email, 'john@example.com');
      expect(testUser.profileImagePath, '/path/to/image.jpg');
      expect(testUser.createdAt, testDate);
      expect(testUser.favoriteCount, 5);
      expect(testUser.uploadCount, 3);
    });

    test('should create User with default values', () {
      final user = User(
        id: 'test_id',
        name: 'John Doe',
        email: 'john@example.com',
        createdAt: testDate,
      );

      expect(user.favoriteCount, 0);
      expect(user.uploadCount, 0);
      expect(user.profileImagePath, null);
    });

    group('copyWith method', () {
      test('should return same user when no parameters provided', () {
        final copiedUser = testUser.copyWith();
        
        expect(copiedUser.id, testUser.id);
        expect(copiedUser.name, testUser.name);
        expect(copiedUser.email, testUser.email);
        expect(copiedUser.profileImagePath, testUser.profileImagePath);
        expect(copiedUser.createdAt, testUser.createdAt);
        expect(copiedUser.favoriteCount, testUser.favoriteCount);
        expect(copiedUser.uploadCount, testUser.uploadCount);
      });

      test('should update only provided parameters', () {
        final copiedUser = testUser.copyWith(
          name: 'Jane Doe',
          favoriteCount: 10,
        );

        expect(copiedUser.name, 'Jane Doe');
        expect(copiedUser.favoriteCount, 10);
        expect(copiedUser.id, testUser.id);
        expect(copiedUser.email, testUser.email);
        expect(copiedUser.uploadCount, testUser.uploadCount);
      });
    });

    group('JSON serialization', () {
      test('should convert to JSON correctly', () {
        final json = testUser.toJson();

        expect(json['id'], 'test_id');
        expect(json['name'], 'John Doe');
        expect(json['email'], 'john@example.com');
        expect(json['profileImagePath'], '/path/to/image.jpg');
        expect(json['createdAt'], testDate.millisecondsSinceEpoch);
        expect(json['favoriteCount'], 5);
        expect(json['uploadCount'], 3);
      });

      test('should create from JSON correctly', () {
        final json = {
          'id': 'test_id',
          'name': 'John Doe',
          'email': 'john@example.com',
          'profileImagePath': '/path/to/image.jpg',
          'createdAt': testDate.millisecondsSinceEpoch,
          'favoriteCount': 5,
          'uploadCount': 3,
        };

        final user = User.fromJson(json);

        expect(user.id, 'test_id');
        expect(user.name, 'John Doe');
        expect(user.email, 'john@example.com');
        expect(user.profileImagePath, '/path/to/image.jpg');
        expect(user.createdAt, testDate);
        expect(user.favoriteCount, 5);
        expect(user.uploadCount, 3);
      });

      test('should handle missing optional fields in JSON', () {
        final json = {
          'id': 'test_id',
          'name': 'John Doe',
          'email': 'john@example.com',
          'profileImagePath': null,
          'createdAt': testDate.millisecondsSinceEpoch,
        };

        final user = User.fromJson(json);

        expect(user.favoriteCount, 0);
        expect(user.uploadCount, 0);
        expect(user.profileImagePath, null);
      });
    });

    group('Helper methods', () {
      test('should return correct initials for full name', () {
        final user = User(
          id: 'test_id',
          name: 'John Doe',
          email: 'john@example.com',
          createdAt: testDate,
        );

        expect(user.initials, 'JD');
      });

      test('should return correct initials for single name', () {
        final user = User(
          id: 'test_id',
          name: 'John',
          email: 'john@example.com',
          createdAt: testDate,
        );

        expect(user.initials, 'J');
      });

      test('should return default initial for empty name', () {
        final user = User(
          id: 'test_id',
          name: '',
          email: 'john@example.com',
          createdAt: testDate,
        );

        expect(user.initials, 'U');
      });

      test('should return correct hasProfileImage status', () {
        final userWithImage = User(
          id: 'test_id',
          name: 'John Doe',
          email: 'john@example.com',
          profileImagePath: '/path/to/image.jpg',
          createdAt: testDate,
        );

        final userWithoutImage = User(
          id: 'test_id',
          name: 'John Doe',
          email: 'john@example.com',
          createdAt: testDate,
        );

        final userWithEmptyPath = User(
          id: 'test_id',
          name: 'John Doe',
          email: 'john@example.com',
          profileImagePath: '',
          createdAt: testDate,
        );

        expect(userWithImage.hasProfileImage, true);
        expect(userWithoutImage.hasProfileImage, false);
        expect(userWithEmptyPath.hasProfileImage, false);
      });
    });
  });
} 