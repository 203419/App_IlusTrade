import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/cart_model.dart';

class CartRemoteDataSource {
  final Dio dio;

  CartRemoteDataSource(this.dio);

  Uri _baseUrl() => Uri.parse('http://44.216.115.253');

  Future<List<CartModel>> getCartItemsByUserId(String userId) async {
    try {
      final response = await dio.get('${_baseUrl()}/carts/$userId');
      final List<dynamic> data = response.data;
      return data.map((json) => CartModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get cart: $e');
    }
  }

  Future<void> addCartItem(CartModel cartItem) async {
    try {
      await dio.post('${_baseUrl()}/carts', data: cartItem.toJson());
    } catch (e) {
      throw Exception('Failed to add cart: $e');
    }
  }

  Future<void> deleteCartItem(int cartItemId) async {
    try {
      await dio.delete('${_baseUrl()}/carts/$cartItemId');
    } catch (e) {
      throw Exception('Failed to delete cart: $e');
    }
  }
}
