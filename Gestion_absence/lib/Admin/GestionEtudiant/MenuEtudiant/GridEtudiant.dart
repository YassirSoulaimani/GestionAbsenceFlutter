import 'package:Gestion_Absence/Admin/GestionEtudiant/addStudent.dart';
import 'package:Gestion_Absence/Admin/GestionEtudiant/deleteStudent.dart';
import 'package:Gestion_Absence/Admin/GestionEtudiant/editStudent.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GridEtudiant extends StatefulWidget {
  final String username;

  GridEtudiant(this.username);

  @override
  _GridEtudiantState createState() => _GridEtudiantState(username);
}

class _GridEtudiantState extends State<GridEtudiant> {
  String username;

  _GridEtudiantState(this.username);

  Items item1 = new Items(
    title: "Ajouter",
    img: "assets/add.png",
    page: "1",
  );

  Items item2 = new Items(
    title: "Modifier",
    img: "assets/edit.png",
    page: "2",
  );

  Items item3 = new Items(
    title: "Supprimer",
    img: "assets/delete.png",
    page: "3",
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [
      item1,
      item2,
      item3,
    ];

    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(
            top: 30,
            left: 100,
            right: 100,
          ),
          crossAxisCount: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: myList.map((data) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  switch (data.page) {
                    case "1":
                      print(username);
                      return AddStudent(username: username);
                      break;
                    case "2":
                      return EditStudent();
                      break;
                    case "3":
                      return DeleteSudent();
                      break;

                    default:
                      return AddStudent();
                  }
                }));
              },
              child: Container(
                height: 10,
                width: 14,
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
