import 'package:Gestion_Absence/Professeur/Pages/Annoncement.dart';
import 'package:Gestion_Absence/Professeur/Pages/Home.dart';
import 'package:Gestion_Absence/Professeur/Pages/PreAttendance.dart';
import 'package:Gestion_Absence/Professeur/Pages/PreEtudiant.dart';
import 'package:Gestion_Absence/Professeur/Pages/ProfileInterface.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class ProfDashboard extends StatefulWidget {
  final String username;
  ProfDashboard({this.username});

  @override
  _ProfDashboardState createState() => _ProfDashboardState(username);
}

class _ProfDashboardState extends State<ProfDashboard> {
  final String username;
  String data;
  GlobalKey _bottomNavigationKey = GlobalKey();

  _ProfDashboardState(this.username);

  int _page = 2;

  final Home _home = Home();
  //final Liste _list = new Liste();
  // final Attendance _attendance = new Attendance();

  Widget _showPage = new Home();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return PreEtudiant(username);
        break;
      case 1:
        return PreAttendance(username);
        break;
      case 2:
        return _home;
        break;
      case 3:
        return ProfileScreen(username);
        break;
      case 4:
        return Anoncement(username);
        break;
      case 5:
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
          Icon(Icons.list, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.perm_identity, size: 30),
          Icon(Icons.add_alert, size: 30),
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
