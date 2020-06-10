import 'package:Gestion_Absence/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Disconnect extends StatelessWidget {
  final String username;

  Disconnect({this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF1F1F3),
        body: AlertDialog(
          title: Text("Vous Etes Sur de Quitter"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text(
                "Se Deconnecter",
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ));
  }
}
