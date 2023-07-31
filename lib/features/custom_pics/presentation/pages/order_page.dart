import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/order_model.dart';
import '../../domain/usecases/order_usecase.dart';

class OrderPage extends StatelessWidget {
  final TextEditingController _themeController = TextEditingController();
  final TextEditingController _styleController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(26, 28, 52, 1),
        elevation: 0,
        title: Text('Pedidos personalizados'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 40, right: 40, top: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _themeController,
                    decoration: const InputDecoration(
                      labelText: 'Tema',
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(61, 64, 99, 1)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(26, 28, 52, 1),
                        ),
                      ),
                    ),
                    // color fromRGBO(26, 28, 52, 1),
                  ),
                  TextField(
                    controller: _styleController,
                    decoration: const InputDecoration(
                      labelText: 'Estilo',
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(61, 64, 99, 1)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(26, 28, 52, 1),
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _sizeController,
                    decoration: const InputDecoration(
                      labelText: 'Tamaño',
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(61, 64, 99, 1)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(26, 28, 52, 1),
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripcion',
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(61, 64, 99, 1)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(26, 28, 52, 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26.0),
                  ElevatedButton(
                    onPressed: () => _createOrder(context),
                    child: Text('Crear pedido', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 3, 29, 69),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    // redirigir a la pantalla de inicio
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createOrder(BuildContext context) async {
    final theme = _themeController.text;
    final style = _styleController.text;
    final size = _sizeController.text;
    final description = _descriptionController.text;

    final orderModel = OrderModel(
      theme: theme,
      style: style,
      size: size,
      description: description,
    );

    final orderUseCase = Provider.of<OrderUseCase>(context, listen: false);

    try {
      final orderData = await orderUseCase.createOrder(orderModel.toJson());
      // Mostrar el AlertDialog con los datos del pedido.
      _showOrderDialog(context, orderData);
      // Limpiar los campos de texto.
      _clearTextFields();
    } catch (e) {
      // Mostrar un AlertDialog con el mensaje de error.
      _showErrorDialog(context, 'An error occurred while creating the order.');
    }
  }

  void _showOrderDialog(BuildContext context, Map<String, dynamic> orderData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order Created'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${orderData['id']}'),
              Text('Theme: ${orderData['theme']}'),
              Text('Style: ${orderData['style']}'),
              Text('Size: ${orderData['size']}'),
              Text('Description: ${orderData['description']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearTextFields() {
    _themeController.clear();
    _styleController.clear();
    _sizeController.clear();
    _descriptionController.clear();
  }
}
