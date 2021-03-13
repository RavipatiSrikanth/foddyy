import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foddyy/screens/home_page.dart';
import 'package:foddyy/screens/signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  'Login',
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
                        Icons.person_outline,
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
                  obscureText: true,
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
              Container(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  onPressed: () {
                    login();
                  },
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0))),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'or',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0))),
                  child: Text(
                    'Signup',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() {
    if (_globalKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Login Succesful");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "error" + onError.toString());
      });
    }
  }
}
