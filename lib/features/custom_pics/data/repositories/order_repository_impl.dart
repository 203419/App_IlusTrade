import '../datasources/order_api.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderApi orderApi;

  OrderRepositoryImpl({required this.orderApi});

  @override
  Future<Map<String, dynamic>> createOrder(
      Map<String, String> orderData) async {
    return await orderApi.createOrder(orderData);
  }

  @override
  Future<List<Map<String, dynamic>>> getOrders() async {
    return await orderApi.getOrders();
  }
}
