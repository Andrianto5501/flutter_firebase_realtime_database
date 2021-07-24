import 'package:flutter/material.dart';

class Remainder extends StatelessWidget {
  Remainder(
      {required this.title,
      required this.nama,
      required this.tanggal,
      required this.jumlah});

  final String title;
  final String nama;
  final String tanggal;
  final String jumlah;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                nama,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                'Rp.' + jumlah,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Row(children: <Widget>[
            Image.asset(
              'assets/images/bell-left.png',
              scale: 1.3,
            ),
            Container(
              transform: Matrix4.translationValues(8.0, -10.0, 0.0),
              margin: EdgeInsets.only(bottom: 80),
              child: Icon(
                Icons.clear,
                color: Colors.white,
                size: 18.0,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
