import 'package:cas_student_assignement/loginform/loginPage.dart';
import 'package:cas_student_assignement/upload_data/upload_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cas_student_assignement/student_registration/student/student_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
String idOfPic = '';
String nameCollection ='';
String nameId ='';
class AddStudentData extends StatefulWidget {
  const AddStudentData({Key? key}) : super(key: key);

  @override
  _AddStudentDataState createState() => _AddStudentDataState();
}

class _AddStudentDataState extends State<AddStudentData> {
  final _fromKey = GlobalKey<FormState>();
  TextEditingController? myNameController;
  TextEditingController? fatherNameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? contactController;
  TextEditingController? addressController;
  StudentModel studentModel = StudentModel();
  String? _imageName = '';
  var fileBytes;
  FilePickerResult? result;
  var uuid = const Uuid();

  @override
  void initState() {
    // TODO: implement initState
    myNameController = TextEditingController();
    fatherNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    contactController = TextEditingController();
    addressController = TextEditingController();
    super.initState();
  }String userName = '';
  String password = '';
  bool isLoading = true;
  Future<void> registerUser({required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('SignUp Successfully.')));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('The password provided is too weak.')));

      } else if (e.code == 'email-already-in-use') {

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('The account already exists for that email.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Something went wrong!')));
    }
  }
  Future<void> getImageFromLocal() async {
    result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);

    if (result?.files.first != null) {
      fileBytes = result?.files.first.bytes;
      _imageName = result?.files.first.name;
      studentModel.setImageName = _imageName!;
      debugPrint(
          '......................UUID................${studentModel.getImageName}');
      studentModel.setImageId = uuid.v4();

      debugPrint(
          '......................UUID................$idOfPic');
      //studentModel.addStudentImage();
      setState(() {});

      // upload file

    }
  }

  Future<void> uploadImageToFirebase() async {
    debugPrint(
        '.......................uploadImage ToFirebase Called....................');
    try {
      await FirebaseStorage.instance
          .ref('${studentModel.getImageId}/${studentModel.getImageName}')
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

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> downloadURL() async {
    String? downloadImage;
    try {
      downloadImage = await storage
          .ref('${studentModel.getImageId}/${studentModel.getImageName}')
          .getDownloadURL();
      debugPrint(
          '......................Download  Image.............$downloadImage');
    } catch (e) {
      debugPrint('......................Error In Image.............$e');
    }

    return downloadImage;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Data'),
      ),
      body: Form(
        key: _fromKey,
        child: Center(
          child: SizedBox(
            width: width * 0.40,
            child: Column(
              children: <Widget>[

                _imageName?.length != 0
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<String?>(
                          future: downloadURL(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Something went wrong'),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    border:
                                    Border.all(width: 2, color: Colors.black),
                                    borderRadius: BorderRadius.circular(50)),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.transparent,
                                  child: ClipOval(
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.memory(
                                        fileBytes,
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      )),
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
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          //backgroundColor: Colors.transparent,
                          radius: 36,
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                      ),
                TextButton(
                  onPressed: () {
                    getImageFromLocal();
                    String name = uuid.v4();
                    debugPrint(
                        '....................Url................$name');
                  },
                  child: const Text('Open Image'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: myNameController,
                      onChanged: (value) {
                        studentModel.setName = value;
                        nameCollection = value;
                        nameId = value;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(' '),
                        FilteringTextInputFormatter.deny('!'),
                        FilteringTextInputFormatter.deny('#'),
                        FilteringTextInputFormatter.deny('%'),
                        FilteringTextInputFormatter.deny('^'),
                        FilteringTextInputFormatter.deny('&'),
                        FilteringTextInputFormatter.deny('*'),
                        FilteringTextInputFormatter.deny('('),
                        FilteringTextInputFormatter.deny(')'),
                        FilteringTextInputFormatter.deny('-'),
                        FilteringTextInputFormatter.deny('+'),
                        FilteringTextInputFormatter.deny('='),
                        FilteringTextInputFormatter.deny(';'),
                        FilteringTextInputFormatter.deny('?'),
                        FilteringTextInputFormatter.deny(','),
                        FilteringTextInputFormatter.deny('~'),
                        FilteringTextInputFormatter.deny(':'),
                        FilteringTextInputFormatter.deny('}'),
                        FilteringTextInputFormatter.deny('{'),
                        FilteringTextInputFormatter.deny('['),
                        FilteringTextInputFormatter.deny(']'),
                        FilteringTextInputFormatter.deny('/'),
                        FilteringTextInputFormatter.deny(']'),
                        FilteringTextInputFormatter.deny('_'),
                        FilteringTextInputFormatter.deny("'"),
                        FilteringTextInputFormatter.deny('"'),
                        FilteringTextInputFormatter.deny('<'),
                        FilteringTextInputFormatter.deny('>'),
                        FilteringTextInputFormatter.deny("\$"),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: fatherNameController,
                      onChanged: (value) {
                        studentModel.setFatherName = value;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Father Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter FatherName';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailController,
                      onChanged: (value) {

                        userName = value;
                        studentModel.setEmail = value;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(' '),
                        FilteringTextInputFormatter.deny('!'),
                        FilteringTextInputFormatter.deny('#'),
                        FilteringTextInputFormatter.deny('%'),
                        FilteringTextInputFormatter.deny('^'),
                        FilteringTextInputFormatter.deny('&'),
                        FilteringTextInputFormatter.deny('*'),
                        FilteringTextInputFormatter.deny('('),
                        FilteringTextInputFormatter.deny(')'),
                        FilteringTextInputFormatter.deny('-'),
                        FilteringTextInputFormatter.deny('+'),
                        FilteringTextInputFormatter.deny('='),
                        FilteringTextInputFormatter.deny(';'),
                        FilteringTextInputFormatter.deny('?'),
                        FilteringTextInputFormatter.deny(','),
                        FilteringTextInputFormatter.deny('~'),
                        FilteringTextInputFormatter.deny(':'),
                        FilteringTextInputFormatter.deny('}'),
                        FilteringTextInputFormatter.deny('{'),
                        FilteringTextInputFormatter.deny('['),
                        FilteringTextInputFormatter.deny(']'),
                        FilteringTextInputFormatter.deny('/'),
                        FilteringTextInputFormatter.deny(']'),
                        FilteringTextInputFormatter.deny('_'),
                        FilteringTextInputFormatter.deny("'"),
                        FilteringTextInputFormatter.deny('"'),
                        FilteringTextInputFormatter.deny('<'),
                        FilteringTextInputFormatter.deny('>'),
                        FilteringTextInputFormatter.deny("\$"),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: passwordController,
                      onChanged: (value) {
                        password = value;
                        studentModel.setPassword = value;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: contactController,
                      onChanged: (value) {
                        studentModel.setContact = int.parse(value);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Contact',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Contact';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: addressController,
                      onChanged: (value) {
                        studentModel.setAddress = value;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Address',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Address';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                isLoading ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                         if (_fromKey.currentState!.validate()) {
                           registerUser(email: userName, password: password);
                           isLoading = false;
                          studentModel.addStudentData();
                          myNameController?.clear();
                          fatherNameController?.clear();
                          emailController?.clear();
                          contactController?.clear();
                          addressController?.clear();
                          passwordController?.clear();
                           uploadImageToFirebase();
                          setState(() {});


                        }

                      },
                      child: const Text('Submit')),
                ): Container(

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
    );
  }

  @override
  void dispose() {
    super.dispose();
    myNameController?.dispose();
    fatherNameController?.dispose();
    emailController?.dispose();
    passwordController?.dispose();
    contactController?.dispose();
    addressController?.dispose();
  }
}
