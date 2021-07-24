import 'package:flutter/material.dart';
import 'package:uas/constants.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({required this.title, required this.onPressed});
  final GestureTapCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      child: new MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(12),
          child: new Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          textColor: primaryTextColor,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          color: primaryColor,
          onPressed: onPressed),
    );
  }
}
