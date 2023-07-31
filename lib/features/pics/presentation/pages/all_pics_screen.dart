import 'package:flutter/material.dart';
import 'package:app_auth/features/pics/domain/entities/pic_entity.dart';
import 'package:provider/provider.dart';
import 'package:app_auth/features/pics/domain/usecases/pic_usecases.dart';
import 'dart:io';
import './ilustrarionDetailpage.dart';

class AllPics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30),
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color.fromRGBO(23, 26, 74, 1),
              Colors.black,
            ],
            radius: 1,
          ),
        ),
        child: StreamBuilder<List<PicEntity>>(
          stream: Provider.of<GetPicsUseCase>(context).call().asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData) {
              return Center(child: Text('No images found'));
            } else {
              final List<PicEntity> pics = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // crossAxisSpacing: 10.0,
                  // mainAxisSpacing: 10.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: pics.length,
                itemBuilder: (context, index) {
                  final image = pics[index].image;
                  final price = pics[index].price;
                  return GestureDetector(
                    onTap: () {
                      // Navegar a la pantalla IllustrationDetailsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IllustrationDetailsPage(
                            userId: pics[index].userId,
                            price: pics[index].price,
                            imageurl: pics[index].image,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: image != null
                                    ? Image.file(
                                        File(image.path),
                                        fit: BoxFit.cover,
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                          // SizedBox(height: 10),
                          // Text(
                          //   '\$$price',
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.white,
                          //   ),
                          // ),
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

  // Función para agregar una ilustración al carrito
  // void _addToCart(Illustration illustration) {
  //   // Implementa la lógica para agregar una ilustración al carrito aquí (si es necesario)
  // }
}

// class IllustrationDetailsPage extends StatelessWidget {
//   // Implementa la pantalla de detalles de la ilustración aquí (si es necesario)
// }

// class CartView extends StatelessWidget {
//   // Implementa la pantalla del carrito aquí (si es necesario)
// }

// class ProfilePage extends StatelessWidget {
//   // Implementa la pantalla de perfil aquí (si es necesario)
// }