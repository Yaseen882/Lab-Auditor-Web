import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cas_student_assignement/Provider/timer_provider.dart';
import 'package:cas_student_assignement/loginform/loginPage.dart';
import 'package:cas_student_assignement/number_creater.dart';
import 'package:cas_student_assignement/student_registration/student/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../student_registration/groups/student_group.dart';
import '../student_registration/student/student.dart';

class UploadData extends StatelessWidget {
  const UploadData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: UploadFile(),
    );
  }
}

class UploadFile extends StatefulWidget {
  const UploadFile({Key? key}) : super(key: key);

  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String? _fileName;
  bool isLoading = true;
  String? _imageName = 'No Image Selected ';
  String? imageId = '';
  var uuid = const Uuid();

  FilePickerResult? result;
  File? fileUpload;
  var fileBytes;
  DateTime? selectedDate;
  String? _selectedTime;

  Future<void> getFileFromLocal() async {
    result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: false);

    if (result?.files.first != null) {
      fileBytes = result?.files.first.bytes;
      print('......................File Bytes.....................$fileBytes');
      _fileName = result?.files.first.name;
      setState(() {});

      // upload file

    }
  }

  Future<void> getImageFromLocal() async {
    result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);

    if (result?.files.first != null) {
      imageId = uuid.v4();

      fileBytes = result?.files.first.bytes;
      _imageName = result?.files.first.name;
      setState(() {});

      // upload file

    }
  }

  Future<void> uploadFileToFirebase() async {
    try {
      await FirebaseStorage.instance
          .ref('uploads/$_fileName')
          .putData(fileBytes!);
      if (kDebugMode) {
        print('...........File Uploaded Successfully...............');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('...........File Not Upload...............');
      }
    }
  }

  Future<void> uploadImageToFirebase() async {
    try {
      await FirebaseStorage.instance
          .ref('$imageId/$_imageName')
          .putData(fileBytes!);
      if (kDebugMode) {
        print('...........File Uploaded Successfully...............');
        showDialog(context: context, builder: (context){
          return AlertDialog(title: Text('Success'),actions: [TextButton(onPressed: () {
            Navigator.pop(context);

          }, child: Text('Okay'))],);
        });
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('...........File Not Upload...............');
      }
    }
  }

  void showDate() async {
    final DateTime? result = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        initialDatePickerMode: DatePickerMode.day,
        lastDate: DateTime(2050));

    if (result != null) {
      setState(() {
        selectedDate = result;
      });
    }
  }

  Future<void> showTime() async {
    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              // change the border color
              primary: Colors.red,
              // change the text color
              onSurface: Colors.purple,
            ),
            // button colors
            buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.green,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (result != null) {
      setState(() {
        _selectedTime = result.format(context);
      });
    }
  }

  int increment = 0;

  void countStream() {
    increment = increment + 1;
    setState(() {});
  }

  Future<Uint8List?> downloadURL() async {
    final firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(groupTitleId!);
    Uint8List? downloadImage;
    try {
      downloadImage = await ref.getData();
      debugPrint(
          '......................Download  Image.............$downloadImage');
    } catch (e) {
      debugPrint('......................Error In Image.............$e');
    }

    return downloadImage;
  }

  Future<void> addDateTime() {


    CollectionReference status = FirebaseFirestore.instance.collection(nameCollection);
    print(
        '............................nameCollection......................$nameCollection');
    return status
        .add({
          'date': selectedDate,
          'time': _selectedTime,
          'hours': hours,
          'minutes': minutes,
          'seconds': seconds,
          'imageID': imageId,
          'imageName': _imageName,
        })
        .then((value) => print('.................User Added...........'))
        .catchError((error) {
          print('..............error....................$error');
        });
  }

  @override
  Widget build(BuildContext context) {
    print('....................Image ID...........................$imageId');
    print('...............................Build......................');
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Workshop Auditor'),
          backgroundColor: Colors.black,
          actions: [
            TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
                },
                child: const Text(
                  'LogOut',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.greenAccent,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/bg.jpg'),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Material(
                elevation: 20,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(41, 187, 255, 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              /* ElevatedButton(
                                child: const Text('Get documents'),
                                onPressed: getFileFromLocal,
                              ),
                              Center(
                                  child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5)),
                                height: 40,
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.description),
                                      Text('$_fileName')
                                    ],
                                  ),
                                ),
                              )),*/
                              Container(
                                height: 220,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Center(
                                            child: Container(
                                          decoration: const BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  224, 245, 255, 1),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                              )),
                                          height: 40,
                                          width: 200,
                                          child: Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                    Icons.file_upload_outlined),
                                              ),
                                              Text(
                                                '$_imageName',
                                                style: const TextStyle(
                                                    fontSize: 17.0),
                                              )
                                            ],
                                          ),
                                        )),
                                        GestureDetector(
                                          onTap: () {
                                            getImageFromLocal();
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5))),
                                            child: const Center(
                                                child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Open Image',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  224, 245, 255, 1),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                              )),
                                          height: 40,
                                          width: 200,
                                          child: Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.all(8.0),
                                                child:
                                                    Icon(Icons.access_time),
                                              ),
                                              Center(
                                                child: Text(
                                                  _selectedTime != null
                                                      ? _selectedTime!
                                                      : 'No time selected',
                                                  style: const TextStyle(
                                                      fontSize: 17),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showTime();
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5))),
                                            child: const Center(
                                                child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Select Time',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  224, 245, 255, 1),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                              )),
                                          height: 40,
                                          width: 200,
                                          child: Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.date_range),
                                              ),
                                              Center(
                                                child: Text(
                                                  selectedDate != null
                                                      ? DateFormat('dd-M-yyyy')
                                                          .format(selectedDate!)
                                                      : 'No Date selected',
                                                  style: const TextStyle(
                                                      fontSize: 17.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDate();
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5))),
                                            child: const Center(
                                                child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Select Date',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              const StopwatchTimer(),
                            ],
                          ),
                          /*FutureBuilder<Uint8List?>(
                            future: downloadURL(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Something went wrong'),
                                );
                              }
                              if (snapshot.connectionState == ConnectionState.done) {
                                return SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: ListTile(
                                    title: Text('${snapshot.data}'),
                                  ),
                                );
                              } else {
                                const Center(
                                  child: Text('Not Found'),
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),*/
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      isLoading ? GestureDetector(
                        onTap: () {
                          // uploadFileToFirebase();

                          uploadImageToFirebase();
                          isLoading = false;
                          addDateTime();
                        },
                        child: Material(
                          elevation: 1,
                          child: Container(
                            width: 300,
                            height: 40,
                            decoration: BoxDecoration(color: Colors.greenAccent),
                            child: const Center(
                                child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ):Container(

                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black87,),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
