import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_auth/features/profile/domain/entities/user.dart';
import 'package:app_auth/features/profile/presentation/profile_screen.dart';

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final usersRef = FirebaseFirestore.instance.collection('users');
  List<UserProfile> _usersList = [];

  void _searchUsers(String searchText) {
    if (searchText.length >= 1) {
      usersRef
          .where('username', isGreaterThanOrEqualTo: searchText)
          .where('username', isLessThanOrEqualTo: searchText + '\uf8ff')
          .get()
          .then((querySnapshot) {
        List<UserProfile> foundUsers = [];
        querySnapshot.docs.forEach((doc) {
          foundUsers.add(UserProfile(
            imageProfileUrl: doc['imageUrl'],
            username: doc['username'],
            userId: doc['userId'],
          ));
        });
        setState(() {
          _usersList = foundUsers.cast<UserProfile>();
        });
      }).catchError((error) {
        print("Error al realizar la búsqueda: $error");
      });
    } else {
      setState(() {
        _usersList =
            []; // Si el texto de búsqueda es vacío, la lista de usuarios se mantendrá vacía
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _searchUsers,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre de usuario',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Color(0xFF161949)),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _usersList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(
                            userId: _usersList[index].userId,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(_usersList[index].imageProfileUrl),
                      ),
                      title: Text(_usersList[index].username,
                          style: TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
