import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/order_model.dart';
import '../../domain/usecases/order_usecase.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('Lista de Ordenes'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 25),
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color.fromRGBO(23, 26, 74, 1),
              Colors.black,
            ],
            radius: 1,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: Provider.of<OrderUseCase>(context).getAllOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error al cargar las órdenes'));
            } else {
              final orders = snapshot.data ?? [];
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Orden :',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tema: ${order['theme']}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)),
                          Text('Estilo: ${order['style']}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)),
                          Text('Tamaño: ${order['size']}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)),
                          Text('Descripción: ${order['description']}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
