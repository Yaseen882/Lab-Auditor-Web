import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  User? user;
  String? uid;
  String? name;
  String? userEmail;
  String? imageUrl;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Future<User?> signInWithGoogle() async {

    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
    try{
      final UserCredential userCredential =   await FirebaseAuth.instance.signInWithPopup(googleAuthProvider);
      user = userCredential.user;
      print('.....................value of user ...............$user');
      if(user != null){
        uid = user?.uid;
        name = user?.displayName;
        userEmail = user?.email;
        imageUrl = user?.photoURL;
        SharedPreferences  ref = await SharedPreferences.getInstance();
        ref.setBool('auth', true);
        bool? d =  ref.getBool('auth');
        print('.....................value of shared ...............$d');

      }
    } catch(e){
      if (kDebugMode) {
        print('..............Error...........$e');
      }
    }


    return user;
  }
  void signOutWithGoogle() async{
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    SharedPreferences  ref = await SharedPreferences.getInstance();
    ref.setBool('auth', false);
    uid = null;
    name = null;
    userEmail = null;
    imageUrl = null;
    print("User signed out of Google account");
  }
  void show() async{
    SharedPreferences  ref = await SharedPreferences.getInstance();
    bool? d = ref.getBool('auth');
    print('.....................value of ...............$d');
  }

  @override
  Widget build(BuildContext context) {
    show();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: () {
              signInWithGoogle();
            }, child: const Text('signIn')),
            TextButton(onPressed: () {
              signOutWithGoogle();
            }, child: const Text('signOut')),
          ],
        ),
      ),
    );
  }
}
