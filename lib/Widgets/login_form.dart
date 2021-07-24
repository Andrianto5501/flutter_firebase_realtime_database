import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas/Components/customButton.dart';

class LoginForm extends StatefulWidget {
  final FocusNode focusNode;

  const LoginForm({
    Key? key,
    required this.focusNode,
  }) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _uidController = TextEditingController();

  final _loginInFormKey = GlobalKey<FormState>();
  late TextEditingController emailInputController;
  late TextEditingController pwdInputController;

  final auth = FirebaseAuth.instance;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _loginInFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Login App',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              margin: EdgeInsets.only(bottom: 40, top: 5),
              child: Text(
                'Please login first to continue using the application',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 18),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  hintText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                ),
                style: TextStyle(fontSize: 16),
                controller: emailInputController,
                keyboardType: TextInputType.emailAddress,
                focusNode: widget.focusNode,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(15.0),
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                hintText: 'Password',
                fillColor: Colors.white,
                filled: true,
                suffixIcon: Icon(Icons.visibility_off),
              ),
              style: TextStyle(fontSize: 16),
              controller: pwdInputController,
              obscureText: true,
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.centerRight,
                child: Text("Forgot Password?",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ))),
            RoundedButton(
                title: 'Login',
                onPressed: () {
                  widget.focusNode.unfocus();
                  _validateLogin();
                }),
          ],
        ));
  }

  void _validateLogin() {
    FocusScope.of(context).unfocus();

    auth
        .signInWithEmailAndPassword(
            email: emailInputController.text, password: pwdInputController.text)
        .then((_) {
      Navigator.of(context).pushNamed('home');
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
