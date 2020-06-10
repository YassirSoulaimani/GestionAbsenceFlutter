import 'package:Gestion_Absence/Admin/Menu/PreAbs.dart';
import 'package:Gestion_Absence/Admin/Menu/disconnect.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gestion_Absence/Admin/Menu/Parametres.dart';
import 'package:Gestion_Absence/Admin/Menu/Admindashboard.dart';

class MenuAdmin extends StatelessWidget {
  final String username;

  MenuAdmin({this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F1F3),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 110,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Admin Dashboard",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.brown,
                              fontSize: 26,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Admin  " + username,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Color(0xffa29aac),
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      alignment: Alignment.topCenter,
                      icon: Icon(
                        Icons.settings,
                        color: Colors.brown,
                        size: 24,
                      ),
                      onPressed: () {
                        print("clicked");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Parametres(username: username)));
                      },
                    ),
                    IconButton(
                      alignment: Alignment.topCenter,
                      icon: Icon(
                        Icons.equalizer,
                        color: Colors.brown,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => PreAbs()));
                      },
                    ),
                    IconButton(
                      alignment: Alignment.topCenter,
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.brown,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Disconnect()));
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GridDashboard(username)
        ],
      ),
    );
  }
}
