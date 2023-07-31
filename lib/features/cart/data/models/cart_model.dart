import 'package:app_auth/features/cart/domain/entities/cart.dart';

class CartModel extends Cart {
  int? id;
  final String userId;
  final String price;
  final String imageUrl;

  CartModel({
    this.id,
    required this.userId,
    required this.price,
    required this.imageUrl,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['userId'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
