import '../datasources/pic_datasource.dart';
import '../../domain/entities/pic_entity.dart';
import '../../domain/repositories/pic_repository.dart';
import '../models/pic_model.dart';

class PicRepositoryImpl implements PicRepository {
  final PicDataSource dataSource;

  PicRepositoryImpl(this.dataSource);

  @override
  Future<void> savePic(PicEntity pic) async {
    final picModel = PicModel.fromEntity(pic);
    await dataSource.savePic(picModel);
  }

  @override
  Future<List<PicModel>> getPics() {
    return dataSource.getPics();
  }
}
