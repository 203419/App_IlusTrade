import 'package:app_auth/features/cart/data/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_auth/features/cart/domain/entities/cart.dart';
import 'package:app_auth/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:app_auth/features/cart/domain/usecases/add_cart_usecase.dart';
import 'package:app_auth/features/cart/domain/usecases/delete_cart_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// importar io
import 'dart:io';
import 'dart:async';

class CartPage extends StatefulWidget {
  final String userId;

  CartPage({required this.userId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> cartItems = [];
  late Timer _timer;
  double totalSum = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
    _timer =
        Timer.periodic(Duration(seconds: 5), (Timer t) => _fetchCartItems());
  }

  void _fetchCartItems() async {
    final getCartItemsUseCase =
        Provider.of<GetCartItemsUseCase>(context, listen: false);
    cartItems = await getCartItemsUseCase(widget.userId);
    double sum = 0.0;
    for (var cartItem in cartItems) {
      sum += int.tryParse(cartItem.price) ?? 0;
    }
    setState(() {
      totalSum = sum;
    });
  }

  void _deleteCartItem(Cart cartItem) async {
    final deleteCartItemUseCase =
        Provider.of<DeleteCartItemUseCase>(context, listen: false);
    await deleteCartItemUseCase(cartItem.id!);
    _fetchCartItems();
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text('Ilustración eliminada'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final getCartItemsUseCase = Provider.of<GetCartItemsUseCase>(context);
    final deleteCartItemUseCase = Provider.of<DeleteCartItemUseCase>(context);

    return Scaffold(
      body: StreamBuilder<List<Cart>>(
        stream: Provider.of<GetCartItemsUseCase>(context, listen: false)
            .call(widget.userId)
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final cartItems = snapshot.data!;
            return Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color.fromRGBO(23, 26, 74, 1),
                    Colors.black,
                  ],
                  radius: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Total del Carrito: \$${totalSum.toStringAsFixed(2)}', // Mostrar con dos decimales
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 18.0, bottom: 1.0, left: 10.0, right: 10.0),
                        child: ListTile(
                          leading: Image.file(File(cartItem.imageUrl!)),
                          title: Text(
                            'Precio:  ${cartItem.price.toString()}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: () => _deleteCartItem(cartItem),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
