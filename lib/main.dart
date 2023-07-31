import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// user
import 'package:app_auth/features/user/presentation/login_screen.dart';
import 'package:app_auth/features/user/presentation/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:app_auth/features/user/domain/usecases/user_usecase.dart';
import 'package:app_auth/features/user/data/repositories/auth_repository_imp.dart';
import 'package:app_auth/features/user/data/datasources/firebase_datasource.dart';
// profile
import 'package:app_auth/features/profile/data/datasources/firebase_user_datasource.dart';
import 'package:app_auth/features/profile/data/repositories/user_repository_impl.dart';
import 'package:app_auth/features/profile/domain/usecases/get_user_usecase.dart';
import 'package:app_auth/features/profile/domain/usecases/update_user_usecase.dart';
import 'package:app_auth/features/profile/domain/usecases/upload_image_usecase.dart';
import 'package:image_picker/image_picker.dart';
// pics
import 'package:app_auth/features/pics/domain/usecases/pic_usecases.dart';
import 'package:app_auth/features/pics/data/repositories/pic_repository_impl.dart';
import 'package:app_auth/features/pics/data/datasources/pic_datasource.dart';

// orders
import 'package:app_auth/features/custom_pics/data/datasources/order_api.dart';
import 'package:app_auth/features/custom_pics/data/repositories/order_repository_impl.dart';
import 'package:app_auth/features/custom_pics/domain/usecases/order_usecase.dart';
import 'package:app_auth/features/custom_pics/presentation/pages/order_page.dart';
import 'package:app_auth/features/custom_pics/presentation/pages/view_orders.dart';
import 'package:http/http.dart' as http;

// carts
import 'package:app_auth/features/cart/data/datasources/cart_datasource.dart';
import 'package:app_auth/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:app_auth/features/cart/domain/usecases/add_cart_usecase.dart';
import 'package:app_auth/features/cart/domain/usecases/delete_cart_usecase.dart';
import 'package:app_auth/features/cart/domain/usecases/get_cart_usecase.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  final dio = Dio();

  runApp(
    MultiProvider(
      providers: [
        // login and register
        Provider<SignUpUseCase>(
          create: (context) => SignUpUseCase(
            UserRepositoryImpl(
              FirebaseUserDataSource(
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          ),
        ),
        Provider<SignInUseCase>(
          create: (context) => SignInUseCase(
            UserRepositoryImpl(
              FirebaseUserDataSource(
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          ),
        ),
        Provider<SignOutUseCase>(
          create: (context) => SignOutUseCase(
            UserRepositoryImpl(
              FirebaseUserDataSource(
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          ),
        ),

        // profile
        Provider<GetUserUseCase>(
          create: (_) => GetUserUseCase(
            UserProfileRepositoryImpl(
              FirebaseUserProfileDataSource(
                firestore: FirebaseFirestore.instance,
                firebaseStorage: FirebaseStorage.instance,
                imagePicker: ImagePicker(),
              ),
            ),
          ),
        ),
        Provider<UpdateUserUseCase>(
          create: (_) => UpdateUserUseCase(
            UserProfileRepositoryImpl(
              FirebaseUserProfileDataSource(
                firestore: FirebaseFirestore.instance,
                firebaseStorage: FirebaseStorage.instance,
                imagePicker: ImagePicker(),
              ),
            ),
          ),
        ),
        Provider<UploadProfileImageUseCase>(
          create: (_) => UploadProfileImageUseCase(
            UserProfileRepositoryImpl(
              FirebaseUserProfileDataSource(
                firestore: FirebaseFirestore.instance,
                firebaseStorage: FirebaseStorage.instance,
                imagePicker: ImagePicker(),
              ),
            ),
          ),
        ),

        // pics
        Provider<GetPicsUseCase>(
          create: (context) => GetPicsUseCase(
            PicRepositoryImpl(
              FirebasePicDataSource(
                firestore: FirebaseFirestore.instance,
                storage: FirebaseStorage.instance,
              ),
            ),
          ),
        ),
        Provider<SavePicUseCase>(
          create: (context) => SavePicUseCase(
            PicRepositoryImpl(
              FirebasePicDataSource(
                firestore: FirebaseFirestore.instance,
                storage: FirebaseStorage.instance,
              ),
            ),
          ),
        ),

        // cart

        Provider<GetCartItemsUseCase>(
          create: (context) => GetCartItemsUseCase(
            CartRepositoryImpl(
              CartRemoteDataSource(dio),
            ),
          ),
        ),
        Provider<AddCartItemUseCase>(
          create: (context) => AddCartItemUseCase(
            CartRepositoryImpl(
              CartRemoteDataSource(dio),
            ),
          ),
        ),
        Provider<DeleteCartItemUseCase>(
          create: (context) => DeleteCartItemUseCase(
            CartRepositoryImpl(
              CartRemoteDataSource(dio),
            ),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // id del usuario
    // final userId = FirebaseAuth.instance.currentUser!.uid;

    const baseUrl =
        'https://icdy6ymktc.execute-api.us-east-1.amazonaws.com/apigateway/';
    final httpClient = http.Client();
    final orderApi = OrderApi(baseUrl: baseUrl, httpClient: httpClient);
    final orderRepository = OrderRepositoryImpl(orderApi: orderApi);
    final orderUseCase = OrderUseCase(repository: orderRepository);

    return MultiProvider(
      providers: [
        Provider.value(value: orderApi),
        Provider.value(value: orderRepository),
        Provider.value(value: orderUseCase),
      ],
      child: MaterialApp(
        title: 'Mi aplicación',
        initialRoute: '/',
        routes: {
          '/': (context) => Login(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => BottomNavigationBarDemo(),
          '/order': (context) => OrderPage(),
          '/view_orders': (context) => OrderListPage(),
        },
      ),
    );
  }
}
