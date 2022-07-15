import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../upload_data/upload_file.dart';

class LoginForm extends StatefulWidget {
  final paddingTopForm, fontSizeTextField, fontSizeTextFormField, spaceBetweenFields, iconFormSize;
  final spaceBetweenFieldAndButton, widthButton, fontSizeButton, fontSizeForgotPassword, fontSizeSnackBar, errorFormMessage;

  LoginForm(
      this.paddingTopForm, this.fontSizeTextField, this.fontSizeTextFormField, this.spaceBetweenFields, this.iconFormSize, this.spaceBetweenFieldAndButton,
      this.widthButton, this.fontSizeButton, this.fontSizeForgotPassword, this.fontSizeSnackBar, this.errorFormMessage
      );

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  String userName = '';

  String password = '';

  Future<void> registerUser({required String email, required String password}) async {

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password:password,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Successfully')));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadFile(),));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Wrong password provided for that user.')));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final double widthSize = MediaQuery.of(context).size.width;
    final double heightSize = MediaQuery.of(context).size.height;

    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.only(left: widthSize * 0.05, right: widthSize * 0.05, top: heightSize * widget.paddingTopForm),
            child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Email', style: TextStyle(
                          fontSize: widthSize * widget.fontSizeTextField,
                          fontFamily: 'Poppins',
                          color: Colors.white)
                      )
                  ),
                  TextFormField(

                      controller: _usernameController,
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'Please enter UserName!';
                        }
                      },
                      onChanged:(value){
                        userName = value;
                      },
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2)
                        ),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2)
                        ),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2)
                        ),
                        labelStyle: const TextStyle(color: Colors.white),
                        errorStyle: TextStyle(color: Colors.white, fontSize: widthSize * widget.errorFormMessage),
                        prefixIcon: Icon(
                          Icons.person,
                          size: widthSize * widget.iconFormSize,
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white, fontSize: widget.fontSizeTextFormField)
                  ),
                  SizedBox(height: heightSize * widget.spaceBetweenFields),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Password', style: TextStyle(
                          fontSize: widthSize * widget.fontSizeTextField,
                          fontFamily: 'Poppins',
                          color: Colors.white)
                      )
                  ),
                  TextFormField(
                      obscureText: true,

                      controller: _passwordController,
                      validator: (value) {
                        if(value!.isEmpty) {
                          return 'Please enter Password!';
                        }
                      },
                      onChanged:(value){
                        password = value;
                      },
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2)
                        ),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2)
                        ),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2)
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        errorStyle: TextStyle(color: Colors.white, fontSize: widthSize * widget.errorFormMessage),
                        prefixIcon: Icon(
                          Icons.lock,
                          size: widthSize * widget.iconFormSize,
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white, fontSize: widget.fontSizeTextFormField)
                  ),
                  SizedBox(height: heightSize * widget.spaceBetweenFieldAndButton),
                 isLoading ? FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      padding: EdgeInsets.fromLTRB(widget.widthButton, 15, widget.widthButton, 15),
                      color: Colors.white,
                      onPressed: () async {
                       // Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadFile(),));
                        if(_formKey.currentState!.validate()) {
                          isLoading = false;
                          registerUser(email: userName, password: password);


                        }
                      },
                      child: Text('LOGIN', style: TextStyle(
                          fontSize: widthSize * widget.fontSizeButton,
                          fontFamily: 'Poppins',
                          color: Color.fromRGBO(41, 187, 255, 1))
                      )
                  ):Container(

            padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black87,),
      child: CircularProgressIndicator(color: Colors.white),
    ),



                ]
            )
        )
    );
  }
}