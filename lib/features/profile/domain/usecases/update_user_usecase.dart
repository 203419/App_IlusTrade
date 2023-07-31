import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserProfileRepository repository;

  UpdateUserUseCase(this.repository);

  Future<void> call(String userId, UserProfile user) async {
    await repository.updateUser(userId, user);
  }
}