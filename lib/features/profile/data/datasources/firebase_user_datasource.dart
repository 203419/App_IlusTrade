import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_auth/features/profile/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';

abstract class ProfileUserDataSource {
  Stream<UserProfileModel> getUser(String userId);
  Future<void> updateUser(String userId, UserProfileModel user);
  Future<String> uploadProfileImage(String userId);
}

class FirebaseUserProfileDataSource implements ProfileUserDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  final ImagePicker imagePicker;
  // id del usuario actual
  // final String userId = FirebaseAuth.instance.currentUser!.uid;
  // nombre del usuario actual
  final String userName = FirebaseAuth.instance.currentUser!.displayName!;

  FirebaseUserProfileDataSource({
    required this.firestore,
    required this.firebaseStorage,
    required this.imagePicker,
  });

  @override
  @override
  Stream<UserProfileModel> getUser(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
      (snapshot) {
        if (snapshot.exists) {
          return UserProfileModel.fromMap(
              snapshot.data() as Map<String, dynamic>);
        } else {
          // Aquí creamos un usuario con datos por defecto
          UserProfileModel user = UserProfileModel(
            imageProfileUrl:
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
            username: userName,
            userId: userId,
          );
          try {
            updateUser(userId, user);
          } catch (e) {
            print('Error al actualizar el usuario: $e');
          }
          return user;
        }
      },
    );
  }

  @override
  Future<void> updateUser(String userId, UserProfileModel user) {
    return firestore.collection('users').doc(userId).set(user.toMap());
  }

  @override
  Future<String> uploadProfileImage(String userId) async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    final path = '${userId}/${Path.basename(pickedFile!.path)}';

    final ref = firebaseStorage.ref(path);
    final uploadTask = ref.putFile(File(pickedFile.path));

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}