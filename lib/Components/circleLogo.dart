import 'package:flutter/material.dart';
import 'package:uas/constants.dart';

class circleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 140,
        height: 140,
        transform: Matrix4.translationValues(0.0, -100.0, 0.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryColor, width: 8),
          borderRadius: BorderRadius.circular(70),
        ),
        child: Text('A',
            style: TextStyle(
                fontSize: 80,
                color: Colors.blue,
                fontWeight: FontWeight.bold)));
  }
}
