import 'package:cas_student_assignement/student_registration/groups/student_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

String? courseTitleId;

class StudentCourses extends StatefulWidget {
  const StudentCourses({Key? key}) : super(key: key);

  @override
  _StudentCoursesState createState() => _StudentCoursesState();
}

class _StudentCoursesState extends State<StudentCourses> {
  List coursesList = [];
  DocumentSnapshot? documentSnapshot;
  CollectionReference reference =
      FirebaseFirestore.instance.collection('courses');

  Future<QuerySnapshot> getStudentCourses() async {
    QuerySnapshot querySnapshot = await reference.get();
    if (kDebugMode) {
      print(
          '...............Query Snapshot..................${querySnapshot.size}');
    }
    coursesList = querySnapshot.docs.map((doc) => doc['courseTitle']).toList();
    if (kDebugMode) {
      print('...............coursesList..................$coursesList');
    }
    return querySnapshot;
  }

  @override
  Widget build(BuildContext context) {
    /*double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;*/
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(224, 245, 255, 1),
        title: const Text(
          'Select Courses',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: getStudentCourses(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return GridView.builder(
              itemCount: coursesList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: GestureDetector(
                    onTap: () {
                      documentSnapshot = snapshot.data?.docs[index];
                      courseTitleId = documentSnapshot?.id;
                      if (kDebugMode) {
                        print(
                            '.......................course Id.................$courseTitleId');
                      }

                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const StudentGroup();
                        },
                      ));
                    },
                    child: Container(

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(41, 187, 255, 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              width: 100,
                              height: 100,
                              child: const Image(
                                color: Colors.white,
                                fit: BoxFit.cover,
                                image:
                                    AssetImage('assets/images/courseIcon.png'),
                              )),
                          Center(
                            child: Text('${coursesList[index]}',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight:FontWeight.bold),),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
            );
          } else {
            const Center(
              child: Text('Courses not found!'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
