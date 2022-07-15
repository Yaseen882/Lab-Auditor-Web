
import 'package:cas_student_assignement/loginform/loginPage.dart';
import 'package:cas_student_assignement/student_registration/course/student_courses.dart';
import 'package:firebase_core/firebase_core.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (fb.Firebase.apps.isEmpty) {
    fb.Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDxJ7fg3vKb3mKAJ6l-vDJiSA2kgGTm4QU',
          appId: '1:795767734836:web:a643be85228175edff8061',
          messagingSenderId: '795767734836',
          authDomain: "studentassignement-f61b2.firebaseapp.com",
          storageBucket: 'studentassignement-f61b2.appspot.com',
          measurementId: "G-FL0L7N1Y2R",
          projectId: 'studentassignement-f61b2'),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
