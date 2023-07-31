import 'dart:io';
import '../../domain/entities/pic_entity.dart';

class PicModel extends PicEntity {
  PicModel({
    required String userId,
    required int price,
    File? image,
    required final DateTime timestamp,
  }) : super(
          userId: userId,
          price: price,
          image: image,
          timestamp: timestamp,
        );

  factory PicModel.fromJson(Map<String, dynamic> json) {
    return PicModel(
      userId: json['userId'],
      price: json['price'],
      image: json['image'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'price': price,
      // 'image': image,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  PicModel copyWith({
    String? userId,
    int? price,
    File? image,
    DateTime? timestamp,
  }) {
    return PicModel(
      userId: userId ?? this.userId,
      price: price ?? this.price,
      image: image ?? this.image,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory PicModel.fromEntity(PicEntity pic) {
    return PicModel(
      userId: pic.userId,
      price: pic.price,
      image: pic.image,
      timestamp: pic.timestamp,
    );
  }
}
