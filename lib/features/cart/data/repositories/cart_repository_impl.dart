import '../datasources/cart_datasource.dart';
import 'package:app_auth/features/cart/domain/entities/cart.dart';
import 'package:app_auth/features/cart/domain/repositories/cart_repository.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Cart>> getCartItemsByUserId(String userId) async {
    final cartItems = await remoteDataSource.getCartItemsByUserId(userId);
    return cartItems.map((cartItem) => cartItem).toList();
  }

  @override
  Future<void> addCartItem(Cart cartItem) async {
    final cartModel = CartModel(
      userId: cartItem.userId,
      price: cartItem.price,
      imageUrl: cartItem.imageUrl,
    );
    await remoteDataSource.addCartItem(cartModel);
  }

  @override
  Future<void> deleteCartItem(int cartItemId) async {
    await remoteDataSource.deleteCartItem(cartItemId);
  }
}
