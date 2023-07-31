import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_auth/features/profile/presentation/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_auth/features/pics/presentation/pages/all_pics_screen.dart';
import 'package:app_auth/features/profile/presentation/search_profile.dart';
import 'package:app_auth/features/cart/presentation/pages/cart_page.dart';

class BottomNavigationBarDemo extends StatefulWidget {
  @override
  _BottomNavigationBarDemoState createState() =>
      _BottomNavigationBarDemoState();
}

class _BottomNavigationBarDemoState extends State<BottomNavigationBarDemo> {
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  int _currentIndex = 0;
  final List<Widget> _screens = [
    AllPics(),
    UserSearchPage(),
    UserProfileScreen(
      userId: FirebaseAuth.instance.currentUser?.uid ?? '',
    ),
    CartPage(userId: FirebaseAuth.instance.currentUser?.uid ?? ''),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'User',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      label: 'Cart',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: _bottomNavBarItems,
          selectedItemColor: Color(0xFF161949),
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
