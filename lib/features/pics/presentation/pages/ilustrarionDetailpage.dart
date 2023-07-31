import 'dart:io';
import 'package:flutter/material.dart';
import 'fullImagepage.dart';
import 'package:app_auth/features/profile/presentation/profile_screen.dart';
import 'package:app_auth/features/cart/data/models/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:app_auth/features/cart/domain/usecases/add_cart_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IllustrationDetailsPage extends StatelessWidget {
  final String userId;
  final int? price;
  final File? imageurl;

  const IllustrationDetailsPage({
    required this.userId,
    required this.price,
    required this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    // current user id de firebase
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    final addCartItemUseCase = Provider.of<AddCartItemUseCase>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color.fromRGBO(23, 26, 74, 1), // Color central del degradado
              Colors.black, // Color exterior del degradado
            ],
            radius:
                1, // Radio del degradado (1 = desde el centro hasta los bordes de la pantalla)
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // centrar la imagen

                GestureDetector(
                    onTap: () {
                      // Mostrar la imagen en su tamaño original en una pantalla de detalles separada
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullImagePage(imageUrl: imageurl!),
                        ),
                      );
                    },
                    child: Image.file(
                      imageurl!,
                      height: 300,
                      fit: BoxFit.cover,
                    )),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Detalles de la Ilustración',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255,
                              255), // Color de las letras en blanco
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Precio: \$${price}',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255,
                                255)), // Color de las letras en blanco
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Navegar al perfil del artista
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfileScreen(
                                userId: userId,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Ir al perfil del artista',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 3, 29, 69)),
                        ),
                        style: ElevatedButton.styleFrom(
                          // fondo color blanco y bordes redondeados con un padding interno
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final cartItem = CartModel(
              userId: currentUserId!,
              price: price.toString(),
              imageUrl: imageurl!.path,
            );
            await addCartItemUseCase(cartItem);
            ScaffoldMessenger.of(context).showSnackBar(
              // color de la barra de notificación verde
              const SnackBar(
                backgroundColor: Color.fromARGB(255, 55, 183, 53),
                content: Text('Ilustración añadida al carrito'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          foregroundColor: const Color.fromARGB(
              255, 3, 29, 69), // Cambiar el color del icono
          backgroundColor: Colors.white,
          child: const Icon(Icons
              .add_shopping_cart) // Cambiar el color del círculo que rodea el icono
          ),
    );
  }
}
