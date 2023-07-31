import '../entities/pic_entity.dart';
import '../repositories/pic_repository.dart';

class GetPicsUseCase {
  final PicRepository repository;

  GetPicsUseCase(this.repository);

  Future<List<PicEntity>> call() {
    return repository.getPics();
  }
}

class SavePicUseCase {
  final PicRepository repository;

  SavePicUseCase(this.repository);

  Future<void> call(PicEntity pic) async {
    await repository.savePic(pic);
  }
}
