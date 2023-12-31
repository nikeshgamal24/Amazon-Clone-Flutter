import 'package:amazon_clone_flutter/constants/global_variables.dart';
import 'package:amazon_clone_flutter/features/account/screens/account_screen.dart';
import 'package:amazon_clone_flutter/features/auth/home/screens/home_screen.dart';
import 'package:amazon_clone_flutter/features/cart/screens/cart_screen.dart';
import 'package:amazon_clone_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
class BottomBar extends StatefulWidget {
  static const routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth=5;

//to correctly show the information
  List<Widget> pages=[
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];

  void updatePage(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCarlen = context.watch<UserProvider>().user.cart!.length;

    return Scaffold(
      body: pages[_page],
      //for the home screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
       backgroundColor: GlobalVariables.backgroundColor,
       iconSize: 28,
       // to determine we move the top horizontal line to the item wheere we do click indeed
       onTap: updatePage,
        items: [
          BottomNavigationBarItem(icon: Container(
            width: bottomBarWidth,
            decoration: BoxDecoration(
              border: Border(top:BorderSide(
                color: _page == 0? GlobalVariables.selectedNavBarColor:GlobalVariables.backgroundColor,
                width: bottomBarBorderWidth,
              ),
              ),
            ),
          child: const Icon(Icons.home_outlined),
          ),
          label: '',
          ),

          //For the account
          BottomNavigationBarItem(icon: Container(
            width: bottomBarWidth,
            decoration: BoxDecoration(
              border: Border(top:BorderSide(
                color: _page == 1? GlobalVariables.selectedNavBarColor:GlobalVariables.backgroundColor,
                width: bottomBarBorderWidth,
              ),
              ),
            ),
          child: const Icon(Icons.person_outline_outlined),
          ),
          label: '',
          ),

          //For the cart
          BottomNavigationBarItem(icon: Container(
            width: bottomBarWidth,
            decoration: BoxDecoration(
              border: Border(top:BorderSide(
                color: _page == 2? GlobalVariables.selectedNavBarColor:GlobalVariables.backgroundColor,
                width: bottomBarBorderWidth,
              ),
              ),
            ),
          child: badges.Badge(
            badgeContent: Text(userCarlen.toString()),
            badgeStyle:const badges.BadgeStyle(
              elevation: 0,
              badgeColor: Colors.white,
            ),
            child:const Icon(
              Icons.shopping_cart_outlined,
              ),
            ),
          ),
          label: '',
          ),
        ],
      ),
    );
  }
}