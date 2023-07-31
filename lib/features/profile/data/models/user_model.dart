import 'package:app_auth/features/profile/domain/entities/user.dart';

class UserProfileModel {
  final String imageProfileUrl;
  final String username;
  final String userId;

  UserProfileModel({
    required this.imageProfileUrl,
    required this.username,
    required this.userId,
  });

  UserProfile toDomain() {
    return UserProfile(
      imageProfileUrl: imageProfileUrl,
      username: username,
      userId: userId,
    );
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> data) {
    return UserProfileModel(
      imageProfileUrl: data['imageUrl'] ?? '',
      username: data['username'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageProfileUrl,
      'username': username,
      'userId': userId,
    };
  }
}
