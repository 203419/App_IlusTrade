abstract class OrderRepository {
  Future<Map<String, dynamic>> createOrder(Map<String, String> orderData);
  Future<List<Map<String, dynamic>>> getOrders();
}
