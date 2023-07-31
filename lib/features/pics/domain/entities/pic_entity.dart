import 'dart:io';

class PicEntity {
  final String userId;
  final int price;
  File? image;
  final DateTime timestamp;

  PicEntity({
    required this.userId,
    required this.price,
    this.image,
    required this.timestamp,
  });
}
