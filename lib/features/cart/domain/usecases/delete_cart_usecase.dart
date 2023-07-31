import '../repositories/cart_repository.dart';

class DeleteCartItemUseCase {
  final CartRepository _repository;

  DeleteCartItemUseCase(this._repository);

  Future<void> call(int cartItemId) async {
    return await _repository.deleteCartItem(cartItemId);
  }
}
