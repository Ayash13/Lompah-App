import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import 'login_page.dart';

/// This is the documentation for the HiddenDrawer class which extends the Stateful Widget
class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  /// This function returns the state object that will be associated with the HiddenDrawer widget below.
  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

/// This is the _HiddenDrawerState class that extends the State class and contains the build method for the HiddenDrawer widget
class _HiddenDrawerState extends State<HiddenDrawer> {
  /// This is the build method for the HiddenDrawer widget which returns a Scaffold widget
  @override
  Widget build(BuildContext context) {
    /// This is a List of ScreenHiddenDrawer objects which contain the pages of the Hidden Drawer
    List<ScreenHiddenDrawer> _pages = [];

    /// Here we are creating a new ScreenHiddenDrawer which will serve as the sign-out page with an ItemHiddenMenu widget
    _pages = [
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

    /// This returns the scaffold widget which contains the user's screens in the Hidden Drawer
    return Scaffold(
      body: HiddenDrawerMenu(
        screens: _pages,
        backgroundColorMenu: Colors.grey,
        initPositionSelected: 0,
      ),
    );
  }
}
