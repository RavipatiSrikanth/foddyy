import 'package:flutter/material.dart';
import 'package:foddyy/screens/home_page.dart';
import 'package:foddyy/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _name, _phone, _email, _password;

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _globalKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return value.trim().isNotEmpty ? null : "Enter Name";
                        },
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.person_outline,
                              color: Colors.red,
                            ),
                            hintText: 'Enter Fullname',
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.red),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          return value.length == 10
                              ? null
                              : "Enter Phone Number";
                        },
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.phone_iphone,
                            color: Colors.red,
                          ),
                          hintText: 'Mobile Number',
                          labelText: 'Phone',
                          labelStyle: TextStyle(color: Colors.red),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return value.trim().contains("@")
                              ? null
                              : "Enter Valid Email";
                        },
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.mail_outline,
                              color: Colors.red,
                            ),
                            hintText: 'Enter Email',
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.red),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return value.length >= 6
                              ? null
                              : "Password must be 6 Characters";
                        },
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock_outline,
                            color: Colors.red,
                          ),
                          hintText: 'Enter Password',
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.red),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0))),
                          child: Text(
                            'Back',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 70, vertical: 20),
                        ),
                        RaisedButton(
                          onPressed: () {
                            signUp();
                          },
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0))),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 70, vertical: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void signUp() {
    if (_globalKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Registrtion Successful");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "error" + onError.toString());
        print(onError);
      });
    }
  }
}
