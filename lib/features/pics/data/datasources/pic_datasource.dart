import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../../domain/entities/pic_entity.dart';
import '../models/pic_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

abstract class PicDataSource {
  Future<void> savePic(PicModel pic);
  Future<List<PicModel>> getPics();
}

class FirebasePicDataSource implements PicDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebasePicDataSource({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<void> savePic(PicModel pic) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('not_logged_in');
    }

    final messageRef = firestore.collection('pics').doc();
    final allPicsRef = firestore.collection('all_pics').doc(messageRef.id);
    final messageWithId = pic.copyWith(
      userId: user.uid,
      price: null,
      image: null,
    );

    await messageRef.set(messageWithId.toJson());
    await allPicsRef.set(messageWithId.toJson());

    if (pic.image != null) {
      final imageRef = storage.ref().child('images/${messageRef.id}');
      await imageRef.putFile(pic.image!);
      final image = await imageRef.getDownloadURL();
      await messageRef.update({'image': image});
      await allPicsRef.update({'image': image});
    }
  }

  @override
  Future<List<PicModel>> getPics() async {
    final picsQuery =
        await firestore.collection('pics').orderBy('timestamp').get();
    final List<PicModel> pics = [];

    for (final picDoc in picsQuery.docs) {
      final picData = picDoc.data();
      final picModel = PicModel(
        userId: picData['userId'],
        price: picData['price'],
        image: null,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
            picData['timestamp'] ?? DateTime.now().millisecondsSinceEpoch),
      );

      if (picData.containsKey('image')) {
        final imageUrl = picData['image'];
        final imageFile = await _downloadFile(imageUrl);
        picModel.image = imageFile;
      }

      pics.add(picModel);
    }

    return pics;
  }

  Future<File> _downloadFile(String url) async {
    final uuid = Uuid();
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${uuid.v4()}';
    final file = File(filePath);
    final response = await storage.refFromURL(url).writeToFile(file);
    if (response.state == TaskState.success) {
      return file;
    } else {
      throw Exception('Error downloading file');
    }
  }
}
