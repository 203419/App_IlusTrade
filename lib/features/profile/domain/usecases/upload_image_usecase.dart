import '../repositories/user_repository.dart';

class UploadProfileImageUseCase {
  final UserProfileRepository repository;

  UploadProfileImageUseCase(this.repository);

  Future<String> call(String userId) async {
    return await repository.uploadProfileImage(userId);
  }
}
