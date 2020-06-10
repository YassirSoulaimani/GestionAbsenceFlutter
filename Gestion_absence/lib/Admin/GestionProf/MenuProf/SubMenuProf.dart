import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './GridProf.dart';

class SubMenuProf extends StatelessWidget {
  final String username;

  SubMenuProf({this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F1F3),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Gestion Des Enseignants",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.brown,
                              fontSize: 26,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GridProf(username),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
