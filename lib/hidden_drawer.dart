import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import 'login_page.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  @override
  Widget build(BuildContext context) {
    List<ScreenHiddenDrawer> _pages = [];

    _pages = [
      //sign out
      ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Sign Out",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 25.0),
          colorLineSelected: Colors.teal,
          selectedStyle: TextStyle(color: Colors.white),
        ),
        LoginPage(),
      ),
    ];
    return Scaffold(
      body: HiddenDrawerMenu(
        screens: _pages,
        backgroundColorMenu: Colors.grey,
        initPositionSelected: 0,
      ),
    );
  }
}
