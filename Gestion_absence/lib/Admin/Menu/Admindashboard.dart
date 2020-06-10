import 'package:Gestion_Absence/Admin/GestionEtudiant/MenuEtudiant/SubMenuEtudiant.dart';
import 'package:Gestion_Absence/Admin/GestionFil/MenuFIL/SubMenuFil.dart';
import 'package:Gestion_Absence/Admin/GestionModule/MenuModule/SubMenuModule.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gestion_Absence/Admin/GestionProf/MenuProf/SubMenuProf.dart';

class GridDashboard extends StatefulWidget {
  final String username;

  GridDashboard(this.username);

  @override
  _GridDashboardState createState() => _GridDashboardState(username);
}

class _GridDashboardState extends State<GridDashboard> {
  String username;

  _GridDashboardState(this.username);

  Items item1 = new Items(
    title: "Gestion Des Profs",
    img: "assets/teacher.png",
    page: "1",
  );

  Items item2 = new Items(
    title: "Gestion Des Etudiants",
    img: "assets/graduate.png",
    page: "2",
  );

  Items item3 = new Items(
    title: "Gestion Des Filières",
    img: "assets/elementary.png",
    page: "3",
  );

  Items item4 = new Items(
    title: "Gestion des Modules",
    img: "assets/learning.png",
    page: "4",
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [
      item1,
      item2,
      item3,
      item4,
    ];
    //   var color = 0xff453658;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16, top: 50),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  switch (data.page) {
                    case "1":
                      print(username);
                      return SubMenuProf(username: username);
                      break;
                    case "2":
                      return SubMenuEtudiant(username: username);
                      break;
                    case "3":
                      return SubMenuFil(username: username);
                      break;
                    case "4":
                      return SubMenuMod(username: username);
                      break;
                    default:
                      return SubMenuProf();
                  }
                }));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 75,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String img;
  String page;
  Items({this.title, this.img, this.page});
}
