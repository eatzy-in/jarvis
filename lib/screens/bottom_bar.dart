
import 'package:fancy_bar/fancy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller_central_eatzy/screens/orders_management/order_page.dart';

import 'account_page.dart';
import 'orders_management/order_history.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key? key}) : super(key: key);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    OrderPage.name ("g"), OrderHistory.name("g"),AccountPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FancyBottomBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        items: [
          FancyItem(
            textColor: Colors.orange,
            title: 'Live Orders',
            icon: Icon(Icons.home),
          ),
          FancyItem(
            textColor: Colors.red,
            title: 'Order History',
            icon: Icon(Icons.history),
          ),

          FancyItem(
            textColor: Colors.brown,
            title: 'Account',
            icon: Icon(Icons.supervised_user_circle),
          ),
        ],
      ),
      body: Center(
        child: getElement(),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getElement(){
    return _widgetOptions.elementAt(_selectedIndex);
  }
}
