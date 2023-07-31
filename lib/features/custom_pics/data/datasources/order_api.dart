import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderApi {
  final String baseUrl;
  final http.Client httpClient;

  OrderApi({required this.baseUrl, required this.httpClient});

  Future<Map<String, dynamic>> createOrder(
      Map<String, String> orderData) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/custom-draw'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(orderData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create order');
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/custom-draw'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final orders = json.decode(response.body) as List;
      return orders.map((order) => order as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to get orders');
    }
  }
}
