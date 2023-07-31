import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_auth/features/profile/domain/entities/user.dart';
import 'package:app_auth/features/profile/domain/usecases/get_user_usecase.dart';
import 'package:app_auth/features/profile/domain/usecases/update_user_usecase.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_auth/features/profile/domain/usecases/upload_image_usecase.dart';
import 'package:app_auth/features/pics/domain/usecases/pic_usecases.dart';
import 'package:app_auth/features/pics/domain/entities/pic_entity.dart';
// importar provider

import 'package:app_auth/features/user/domain/usecases/user_usecase.dart';
import 'package:app_auth/features/pics/presentation/pages/ilustrarionDetailpage.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  UserProfileScreen({
    required this.userId,
  });

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late String newImageUrl;
  late String newUsername;
  final TextEditingController usernameController = TextEditingController();
  File? _imageFile;
  // id del usuario actual
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  final TextEditingController _priceController = TextEditingController();

  void _selectProfileImage() async {
    final uploadProfileImageUseCase =
        Provider.of<UploadProfileImageUseCase>(context, listen: false);
    try {
      newImageUrl = await uploadProfileImageUseCase.call(widget.userId);
    } catch (e) {
      // Handle error...
    }
  }

  void _updateUserProfile() async {
    final updateUserUseCase =
        Provider.of<UpdateUserUseCase>(context, listen: false);
    newUsername = usernameController.text;
    await updateUserUseCase.call(
      widget.userId,
      UserProfile(
        imageProfileUrl: newImageUrl,
        username: newUsername,
        userId: widget.userId,
      ),
    );
  }

  Future<void> _pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      _imageFile = File(result.files.single.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final getUserUseCase = Provider.of<GetUserUseCase>(context);
    final singOutUseCase = Provider.of<SignOutUseCase>(context);

    Future<void> _sendPic() async {
      final PicEntity pic = PicEntity(
        userId: widget.userId ?? '',
        price: int.parse(_priceController.text),
        image: _imageFile,
        timestamp: DateTime.now(),
      );
      await Provider.of<SavePicUseCase>(context, listen: false).call(pic);
      _priceController.clear();
      setState(() {
        _imageFile = null;
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          currentUserId == widget.userId
              ? PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        child: Text('Cerrar sesion'),
                        value: 1,
                      ),
                      const PopupMenuItem(
                        child: Text('Ver pedidos'),
                        value: 2,
                      ),
                    ];
                  },
                  icon: Icon(Icons.more_vert),
                  onSelected: (value) async {
                    if (value == 1) {
                      await singOutUseCase.call().then((value) {
                        Navigator.of(context).pushNamed('/');
                      });
                    } else if (value == 2) {
                      Navigator.of(context).pushNamed('/view_orders');
                    }
                  },
                )
              : //texto de hacer pedido personalizado y redirigir a la pantalla OrderPage
              PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text('Hacer pedido'),
                        value: 1,
                      ),
                      // Agrega más opciones...
                    ];
                  },
                  icon: Icon(Icons.more_vert),
                  onSelected: (value) {
                    // cerrar sesion
                    Navigator.of(context).pushNamed('/order');
                  },
                )
        ],
      ),
      backgroundColor: Colors.transparent,
      body: StreamBuilder<UserProfile>(
        stream: getUserUseCase.call(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            // imprimir error snapshot.hasData
            print('la data es: ${snapshot.hasData}');
            return Center(child: Text('No data'));
          } else {
            final user = snapshot.data!;

            newImageUrl = user.imageProfileUrl;
            newUsername = user.username;
            usernameController.text = newUsername;

            return Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color.fromRGBO(
                        23, 26, 74, 1), // Color central del degradado
                    Colors.black, // Color exterior del degradado
                  ],
                  radius:
                      1, // Radio del degradado (1 = desde el centro hasta los bordes de la pantalla)
                ),
              ),
              child: Column(
                children: [
                  // SizedBox(height: 30),
                  currentUserId == widget.userId
                      ? InkWell(
                          onTap: _selectProfileImage,
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  newImageUrl.isEmpty
                                      ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'
                                      : newImageUrl,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                newImageUrl.isEmpty
                                    ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'
                                    : newImageUrl,
                              ),
                            ),
                          ),
                        ),
                  currentUserId == widget.userId
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Container(
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: usernameController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          child: Container(
                            child: Text(
                              user.username,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 5),
                  currentUserId == widget.userId
                      ? ElevatedButton(
                          onPressed: _updateUserProfile,
                          child: Text('Update',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              )),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<List<PicEntity>>(
                      stream: Provider.of<GetPicsUseCase>(context)
                          .call()
                          .asStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final pics = snapshot.data!;
                          final userPics = pics
                              .where((pic) => pic.userId == widget.userId)
                              .toList();
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              // crossAxisSpacing: 10.0,
                              // mainAxisSpacing: 10.0,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: userPics.length,
                            itemBuilder: (context, index) {
                              final pic = userPics[index];
                              final image = pic.image;
                              final price = pic.price;
                              return GestureDetector(
                                // si el user es el mismo que el del perfil, entonces puede editar la foto
                                onTap: currentUserId == widget.userId
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                IllustrationDetailsPage(
                                              userId: pics[index].userId,
                                              price: pics[index].price,
                                              imageurl: pics[index].image,
                                            ),
                                          ),
                                        );
                                      },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                      const SizedBox(height: 10),
                                      Text(
                                        '\$$price',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text('No images found'));
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: currentUserId == widget.userId
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String? price;
                    return AlertDialog(
                      title: Text('Agregar imagen y precio'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            // color de fondo del botón
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF161949),
                            ),
                            onPressed:
                                _pickImage, // Llamar a la función _pickImage para seleccionar una foto
                            child: Text('Seleccionar imagen'),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Precio',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          // color de fondo del botón
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green[400]),
                          onPressed: () {
                            _sendPic();
                            Navigator.pop(
                                context); // Cerrar el cuadro de diálogo
                          },
                          child: Text('Enviar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add, color: Color(0xFF161949)),
              backgroundColor: Colors.white,
            )
          : null,
    );
  }
}
