import 'package:flutter/material.dart';
import 'dart:io';

class FullImagePage extends StatelessWidget {
  final File? imageUrl;

  const FullImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Center(
          child: Image.file(
        imageUrl!,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      )),
    );
  }
}
