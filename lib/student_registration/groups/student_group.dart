
import 'package:cas_student_assignement/student_registration/course/student_courses.dart';
import 'package:cas_student_assignement/student_registration/student/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
String? groupTitleId;
class StudentGroup extends StatefulWidget {
  const StudentGroup({Key? key}) : super(key: key);

  @override
  _StudentGroupState createState() => _StudentGroupState();
}

class _StudentGroupState extends State<StudentGroup> {
  CollectionReference groupReference =
      FirebaseFirestore.instance.collection(courseTitleId!);
  List groupTitleList = [];
  DocumentSnapshot? groupDS;

  Future<QuerySnapshot> getGroupTitle() async {
    print('....................getGroupTitle is Called.....................');
    QuerySnapshot querySnapshot = await groupReference.get();
    groupTitleList =
        querySnapshot.docs.map((doc) => doc['groupTitle']).toList();
    print('....................groupTitleList.....................$groupTitleList');
    return querySnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(224, 245, 255, 1),
        title: const Text(
          'Select Group',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: getGroupTitle(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return GridView.builder(
              itemCount: groupTitleList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(18),
                  child: GestureDetector(
                    onTap: () {
                      groupDS = snapshot.data?.docs[index];
                      groupTitleId = groupDS?.id;
                      if (kDebugMode) {
                        print('.......................group Id...................$groupTitleId');
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddStudentData(),));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(41, 187, 255, 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.school,size: 100,color:Colors.white,),
                          Container(

                            child: Center(
                              child: Text('${groupTitleList[index]}',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight:FontWeight.bold),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            const Center(
              child: Text('Group not found!'),
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
