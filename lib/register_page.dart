import 'package:final_project_2023/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// RegisterPage is a StatefulWidget that displays a registration form for a new user.
///
/// The state of this widget is managed by _RegisterPageState, which extends the State class.
///
/// The registration form includes fields for the user's name, email, and password. Upon successful submission,
/// the user's credentials are authenticated with Firebase Authentication and the user is registered in the system.
///
/// If registration is successful, the user is redirected to the LoginPage. If not, an error message is displayed.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    /// Initialize the FirebaseAuth and GoogleSignIn instances.
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    /// Initialize variables to store user input.
    late String email;
    late String password;
    late String name;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/logo-8.png"),
            alignment: Alignment.topCenter,
            scale: 3,
          ),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 270),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80),
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50.0),
                    Text(
                      "REGISTER",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0),

                    ///login with email and password
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Username',

                          ///label txt color
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: TextField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(330, 50)),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      onPressed: () async {
                        /// Authenticate the user's credentials with Firebase Authentication.
                        try {
                          final UserCredential userCredential =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          final User? user = userCredential.user;
                          if (user != null) {
                            // Update the display name in Firebase.
                            await user.updateProfile(displayName: name);
                            await user.reload();
                            Get.offAll(LoginPage());
                            // Display a success message using GetX.
                            Get.snackbar('Berhasil', 'Berhasil Register',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor:
                                    Color.fromARGB(133, 76, 175, 79),
                                colorText: Colors.white,
                                duration: Duration(seconds: 3),
                                margin: EdgeInsets.all(10),
                                borderRadius: 10);
                          }
                        } catch (e) {
                          /// Display an error message using GetX.
                          Get.snackbar('Gagal', 'Gagal Register',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Color.fromARGB(128, 244, 67, 54),
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                              margin: EdgeInsets.all(10),
                              borderRadius: 10);
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Sudah Punya Akun?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                        TextButton(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Get.offAll(LoginPage());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
