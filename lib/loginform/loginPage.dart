import 'package:cas_student_assignement/upload_data/upload_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../student_registration/course/student_courses.dart';
import 'desktop.dart';

import 'mobile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: const Color.fromRGBO(41, 187, 255, 1),
        actions: [TextButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => StudentCourses(),));
        }, child: const Text('SignUp',style: TextStyle(color: Colors.white),))],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 1024) {
            return MobileMode();
          } else {
            return const DesktopMode();
          }
        },
      ),
    );
  }
}
