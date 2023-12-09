import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Account.dart';
import 'cart.dart';
import 'Home.dart';
/*import 'GalleryStore.dart';*/
/*import 'Store.dart';*/

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedPageIndex = 0;
  var screens = [
    HomeBottomNav(),
    /*const CRUDEoperation(),
    const NotificationBottomNav(),*/
    const AccountBottomNav(),
    CartPage()
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'home',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: screens[selectedPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedPageIndex,
          selectedItemColor: Colors.green,
          items: const [
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.home,color: Colors.green,),
                label: 'Home'),
            /*BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.storefront,color: Colors.green,),
                label: 'Store'),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.browse_gallery,color: Colors.green,),
                label: 'Gallery'),*/
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.person,color: Colors.green,),
                label: 'Account'),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.add_shopping_cart,color: Colors.green,),
                label: 'Cart')
          ],
          onTap: (index) {
            selectedPageIndex = index;
            setState(() {});
          },
        ),
      ),);
  }
}