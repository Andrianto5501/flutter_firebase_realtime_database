import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas/Screens/home_screen.dart';
import 'package:uas/constants.dart';
import 'package:uas/Widgets/login_form.dart';
import 'package:uas/Components/circleLogo.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _uidFocusNode = FocusNode();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      return HomeScreen();
    }

    return GestureDetector(
      onTap: () => _uidFocusNode.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue,
        appBar: AppBar(
            title: Text(
              'Todo App',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor),
            ),
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false),
        body: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 30),
                margin: EdgeInsets.only(top: 100),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: Flex(direction: Axis.vertical, children: <Widget>[
                  circleLogo(),
                  Container(
                      transform: Matrix4.translationValues(0.0, -70.0, 0.0),
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                      child: LoginForm(focusNode: _uidFocusNode)),
                ]),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
