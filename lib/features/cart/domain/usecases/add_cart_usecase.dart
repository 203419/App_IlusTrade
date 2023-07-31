import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class AddCartItemUseCase {
  final CartRepository _repository;

  AddCartItemUseCase(this._repository);

  Future<void> call(Cart cartItem) async {
    return await _repository.addCartItem(cartItem);
  }
}
