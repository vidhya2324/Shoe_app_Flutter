import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/pages/Dashboard_page.dart';
import 'package:shop_app/pages/buildProfile.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/pages/login_page.dart';
import 'package:shop_app/widgets/product_list.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  User? currentUser;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    pages = [
      ProductList(
        currentUser: currentUser,
        showProfileMenu: _showProfileMenu,
      ),
      const CartPage(),
       Dashboard(currentUser: currentUser)
    ];
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LogIn()),
      (route) => false,
    );
  }

  void _showProfileMenu() {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 10, 0),
      items: [
        PopupMenuItem<String>(
          value: "buildprofile",
          child: ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Build Your Profile"),
            onTap: () {
              Navigator.pop(context); // close menu
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuildProfilePage(currentUser: currentUser),
                ),
              );
            },
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: "logout",
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context); // close menu
              _logout();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home"),
      //   actions: [
      //     IconButton(
      //       onPressed: _showProfileMenu,
      //       icon: const Icon(Icons.person_2_outlined),
      //     )
      //   ],
      // ),
      body: IndexedStack(index: currentPage, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        fixedColor: Colors.yellow,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: ' '),
        ],
      ),
    );
  }
}


