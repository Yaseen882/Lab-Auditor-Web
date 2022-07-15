import 'package:cas_student_assignement/student_registration/groups/student_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StudentModel {
  String? _name;
  String? _fatherName;
  String? _email;
  String? _password;
  String? _address;
  int? _contact;
  String? _imageId;
  String? _imageName;


  String? get getImageName => _imageName;

  set setImageName(String value) {
    _imageName = value;
  }

  String? get getImageId => _imageId;

  set setImageId(String value) {
    _imageId = value;
  }

  String? get getName => _name;

  set setName(String value) {
    _name = value;
  }

  String? get getFatherName => _fatherName;

  set setFatherName(String value) {
    _fatherName = value;
  }

  int? get getContact => _contact;

  set setContact(int value) {
    _contact = value;
  }

  String? get getAddress => _address;

  set setAddress(String value) {
    _address = value;
  }

  String? get getPassword => _password;

  set setPassword(String value) {
    _password = value;
  }

  String? get getEmail => _email;

  set setEmail(String value) {
    _email = value;
  }

  final CollectionReference reference = FirebaseFirestore.instance.collection(groupTitleId!);

  Future<void> addStudentData() {
    return reference.add({
      'name': getName,
      'fatherName': getFatherName,
      'email': getEmail,
      'password': getPassword,
      'contact': getContact,
      'address': getAddress,
      'imageId': getImageId,
      'imageName': getImageName
    }).then((value) {

      if (kDebugMode) {
        print('..............student  added..............');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('..............student not added.......Error.......$error');
      }
    });
  }
  Future<void> addStudentImage() {
    if (kDebugMode) {
      print('..............addStudentImage  called..............');
    }
    return reference.add({
      'imageId': getImageId,
      'imageName': getImageName
    }).then((value) {
      if (kDebugMode) {
        print('..............student  added..............');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('..............student not added.......Error.......$error');
      }
    });
  }

}
