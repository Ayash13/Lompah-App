import 'package:final_project_2023/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';

///The [ProfilePage] is a StatefulWidget that displays user's profile information
///such as display name, email and profile picture. It also includes a logout button
///that logs out the user from the application.
class ProfilePage extends StatefulWidget {
  ///The [ProfilePage]'s key. Inherits from [StatefulWidget]'s key.
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ///Builds the widget tree for the [ProfilePage] and returns the widget.
  ///The returned widget is a [Container] with a [Center] containing a [Container]
  ///with a [Column] containing a [SizedBox], a [CircleAvatar], another [SizedBox],
  ///a [GestureDetector] containing a [Text], a [SizedBox], a [Text] and another [GestureDetector]
  ///that contains a [Padding] containing a [Container].
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      FirebaseAuth.instance.currentUser?.photoURL ?? ""),
                ),
                const SizedBox(
                  height: 10,
                ),
                //display name from firebase
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Ganti Username"),
                          content: TextField(
                            onChanged: (value) {
                              setState(() {
                                FirebaseAuth.instance.currentUser
                                    ?.updateDisplayName(value);
                              });
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Batal",
                                  style: TextStyle(color: Colors.black)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Ok",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Center(
                    child: Text(
                      FirebaseAuth.instance.currentUser?.displayName ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    FirebaseAuth.instance.currentUser?.email ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //create logout button
                GestureDetector(
                  onTap: () {
                    logout();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: const Center(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  ///Logs out the current user by calling [FirebaseAuth.instance.signOut()] and
  ///navigating to LoginPage using GetX library.
  void logout() {
    FirebaseAuth.instance.signOut().then((value) {
      Get.offAll(LoginPage());
    });
  }
}
