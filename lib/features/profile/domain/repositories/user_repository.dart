import '../entities/user.dart';

abstract class UserProfileRepository {
  Stream<UserProfile> getUser(String userId);
  Future<void> updateUser(String userId, UserProfile user);
  Future<String> uploadProfileImage(String userId);
}
