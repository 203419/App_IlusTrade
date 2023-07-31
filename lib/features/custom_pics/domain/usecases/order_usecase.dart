import '../repositories/order_repository.dart';

class OrderUseCase {
  final OrderRepository repository;

  OrderUseCase({required this.repository});

  Future<Map<String, dynamic>> createOrder(
      Map<String, String> orderData) async {
    return await repository.createOrder(orderData);
  }

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final orders = await repository.getOrders();
    return orders;
  }
}
