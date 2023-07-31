// import 'dart:io';
import '../entities/pic_entity.dart';

abstract class PicRepository {
  Future<void> savePic(PicEntity pic);
  Future<List<PicEntity>> getPics();
}
