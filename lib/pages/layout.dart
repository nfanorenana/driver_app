import 'package:driver_app/constants/constants.dart';
import 'package:driver_app/domain/user.dart';
import 'package:driver_app/pages/dashboard.dart';
import 'package:driver_app/pages/profile.dart';
import 'package:driver_app/pages/ticket_page.dart';
import 'package:driver_app/util/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({Key key}) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    DashBoard(),
    TicketPage(),
    Profile(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: primary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Tableau de bord',
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            label: 'Contrôle de billet',
            icon: Icon(CupertinoIcons.ticket),
          ),
          BottomNavigationBarItem(
            label: 'Profil',
            icon: Icon(Icons.account_circle),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}
