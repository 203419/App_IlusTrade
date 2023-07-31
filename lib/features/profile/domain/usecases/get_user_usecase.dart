import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase {
  final UserProfileRepository repository;

  GetUserUseCase(this.repository);

  Stream<UserProfile> call(String userId) {
    return repository.getUser(userId);
  }
}
