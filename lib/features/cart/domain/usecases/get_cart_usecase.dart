import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository _repository;

  GetCartItemsUseCase(this._repository);

  Future<List<Cart>> call(String userId) async {
    return await _repository.getCartItemsByUserId(userId);
  }
}
