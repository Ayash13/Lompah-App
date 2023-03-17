import 'package:final_project_2023/main.dart';
import 'package:final_project_2023/register_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// LoginPage class for displaying the Login page UI.
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

/// The state class for the LoginPage which extends StatefulWidget class.
class _LoginPageState extends State<LoginPage> {
  /// Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Google sign in instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// The email string variable declared as late variable
  late String email;

  /// The password string variable declared as late variable
  late String password;

  /// This function is used to signin with google account
  Future<void> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;
    if (user != null) {
      Get.snackbar(
        'Berhasil',
        'Berhasil Login',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color.fromARGB(124, 76, 175, 79),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(10),
        borderRadius: 10,
      );
    }
  }

  /// This function is the build function which builds the widgets
  @override
  Widget build(BuildContext context) {
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
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    //login with email and password
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
                        obscureText: true,
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
                          fixedSize: MaterialStateProperty.all<Size>(
                            Size(330, 50),
                          ),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        onPressed: () async {
                          try {
                            // Signin with email and password using Firebase Auth instance
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            Get.offAll(MyHomePage());
                            // Display Snackbar with success message
                            Get.snackbar(
                              'Berhasil',
                              'Berhasil Login',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Color.fromARGB(124, 76, 175, 79),
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                              margin: EdgeInsets.all(10),
                              borderRadius: 10,
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              // Display Snackbar with error message
                              Get.snackbar(
                                'Gagal',
                                'Email tidak terdaftar',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor:
                                    Color.fromARGB(123, 175, 76, 76),
                                colorText: Colors.white,
                                duration: Duration(seconds: 3),
                                margin: EdgeInsets.all(10),
                                borderRadius: 10,
                              );
                            } else if (e.code == 'wrong-password') {
                              // Display Snackbar with error message
                              Get.snackbar(
                                'Gagal',
                                'Password salah',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor:
                                    Color.fromARGB(123, 175, 76, 76),
                                colorText: Colors.white,
                                duration: Duration(seconds: 3),
                                margin: EdgeInsets.all(10),
                                borderRadius: 10,
                              );
                            }
                          }
                        }),
                    SizedBox(height: 20.0),
                    Text(
                      "Atau Login Dengan Google",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        if (_googleSignIn.currentUser == null) {
                          // Call _signInWithGoogle function
                          _signInWithGoogle().then(
                            (value) => Get.offAll(
                              MyHomePage(),
                            ),
                          );
                        }
                      },
                      child: Card(
                        child: Image.network(
                            'http://pngimg.com/uploads/google/google_PNG19635.png',
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover),
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Belum punya akun?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                        TextButton(
                          child: Text(
                            "DAFTAR",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Get.offAll(RegisterPage());
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
