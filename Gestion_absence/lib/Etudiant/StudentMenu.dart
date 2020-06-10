import 'package:Gestion_Absence/Etudiant/Anonces.dart';
import 'package:Gestion_Absence/Professeur/Pages/Home.dart';
import 'package:Gestion_Absence/Etudiant/graph2.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class StudentMenu extends StatefulWidget {
  final String username;
  StudentMenu({Key key, this.username});

  @override
  _StudentMenuState createState() => _StudentMenuState(username);
}

class _StudentMenuState extends State<StudentMenu> {
  final String username;
  String data;
  GlobalKey _bottomNavigationKey = GlobalKey();
  final key = GlobalKey();

  _StudentMenuState(this.username);

  int _page = 1;

  final Home _home = Home();
  //final Liste _list = new Liste();
  // final Attendance _attendance = new Attendance();

  Widget _showPage = new Home();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return Graph2(username: username);
        break;

      case 1:
        return _home;
        break;
      case 2:
        return Anonce(key: key, username: username);
        break;
      case 3:
        return AlertDialog(
          title: Text("Vous Etes Sur de Quitter"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Se Deconnecter",
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        );

        break;

      default:
        return new Container(
          child: Text("No Page Found"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.brown,
        height: 50,
        index: _page,
        items: <Widget>[
          Icon(Icons.equalizer, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.notifications_none, size: 30),
          Icon(Icons.exit_to_app, size: 30),
        ],
        onTap: (int tappedIndex) {
          setState(() {
            _showPage = _pageChooser(tappedIndex);
          });
        },
      ),
      body: Container(child: Center(child: _showPage)),
    );
  }
}
