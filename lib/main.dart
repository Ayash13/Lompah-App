import 'dart:developer';

import 'package:final_project_2023/chat_page.dart';
import 'package:final_project_2023/home_page.dart';
import 'package:final_project_2023/login_page.dart';
import 'package:final_project_2023/profile.dart';
import 'package:final_project_2023/time_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/instance_manager.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:location/location.dart';
import 'firebase_options.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get.dart';
import 'chat_page.dart';

/// The main function initializes the Flutter framework,
/// sets up Firebase with the given options, and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// The runApp() method runs the app,
  /// using a GetMaterialApp widget as the root widget.
  runApp(
    GetMaterialApp(
      /// The home property of the GetMaterialApp
      /// widget is set to a StreamBuilder widget.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHomePage();
          } else {
            return LoginPage();
          }
        },
      ),

      /// Other properties of the GetMaterialApp widget
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        appBarTheme: AppBarTheme(
          color: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
      ),
    ),
  );
}

/// The MyHomePage widget is a StatefulWidget that
/// creates the HiddenDrawerMenu widget.
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// The _MyHomePageState class is the state class
/// for the MyHomePage widget.
class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final Location _location = Location();
    double? _latitude;
    double? _longitude;

    _location.getLocation().then((value) {
      setState(() {
        _latitude = value.latitude!;
        _longitude = value.longitude!;
      });
    });

    List<ScreenHiddenDrawer> _pages = [];

    /// List of pages or screens to be displayed, each with a title and widget.
    _pages = [
      ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Lapor Sampah",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 25.0),
          colorLineSelected: Colors.white,
          selectedStyle: TextStyle(color: Colors.white),
        ),
        HomePage(),
      ),
      ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Lokasi",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 25.0),
          colorLineSelected: Colors.white,
          selectedStyle: TextStyle(color: Colors.white),
        ),
        TimeLine(),
      ),
      ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Komunitas",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 25.0),
          colorLineSelected: Colors.white,
          selectedStyle: TextStyle(color: Colors.white),
        ),
        ChatPage(),
      ),
      ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Profile",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 25.0),
          colorLineSelected: Colors.white,
          selectedStyle: TextStyle(color: Colors.white),
        ),
        ProfilePage(),
      ),
    ];

    /// Return a HiddenDrawerMenu widget with properties set.
    return HiddenDrawerMenu(
      screens: _pages,
      backgroundColorMenu: Colors.black,
      initPositionSelected: 0,
    );
  }
}
