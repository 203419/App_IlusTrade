import '../entities/cart.dart';

abstract class CartRepository {
  Future<List<Cart>> getCartItemsByUserId(String userId);
  Future<void> addCartItem(Cart cartItem);
  Future<void> deleteCartItem(int cartItemId);
}
