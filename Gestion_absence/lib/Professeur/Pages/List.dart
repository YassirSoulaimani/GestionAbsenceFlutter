import 'package:Gestion_Absence/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';

class Liste extends StatefulWidget {
  final String filiere;
  final String module;
  final String date;
  final String heur;
  Liste({this.filiere, this.module, this.date, this.heur});
  @override
  _ListeState createState() => _ListeState();
}

class _ListeState extends State<Liste> {
  //initState

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  bool selected = false;
  var userStatus = List<bool>();
  List<String> selectedStudents = [];

  Future<List<Etudiant>> _getUsers() async {
    var map = Map<String, dynamic>();
    map['action'] = 'GET_ALL';
    map['id'] = widget.filiere;
    var data = await http.post(
        "http://yassirtestflutter.000webhostapp.com/flutter_login/Attendance/Attendance.php",
        body: map);
    var jsonData = json.decode(data.body);
    List<Etudiant> etudiants = [];

    for (var u in jsonData) {
      Etudiant etudiant = Etudiant(u["id"], u["nom"], u["prenom"], u["email"]);
      etudiants.add(etudiant);
      userStatus.add(false);
    }
    return etudiants;
  }

  String baseUrl = Api.attendance;

  insertApi() async {
    for (var i = 0; i < selectedStudents.length; i++) {
      final response = await http.post(baseUrl, body: {
        'action': "Absence",
        'id_etudiant': selectedStudents[i],
        'id_module': widget.module,
        'status': "absent",
        'date': widget.date,
        'heur': widget.heur,
      });

      print('getStudents Response: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.brown, //change your color here
        ),
        title: new Text(
          'noter absence',
          style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  color: Colors.brown,
                  fontSize: 24,
                  fontWeight: FontWeight.w900)),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.brown),
        child: Column(
          children: <Widget>[
            Container(
              child: FutureBuilder(
                future: _getUsers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //print(snapshot.data);
                  if (snapshot.data == null) {
                    return Container(child: Center(child: Text("Loading...")));
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: ListTile(
                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(
                                          width: 2.0, color: Colors.brown))),
                              child: Icon(Icons.arrow_forward_ios,
                                  color: Colors.brown),
                            ),
                            title: Text(capitalize(snapshot.data[index].nom) +
                                ' ' +
                                capitalize(snapshot.data[index].prenom)),
                            //subtitle: Text(snapshot.data[index].prenom),
                            trailing: Checkbox(
                                value: userStatus[index],
                                activeColor: Colors.brown,
                                onChanged: (bool val) {
                                  setState(() {
                                    userStatus[index] = !userStatus[index];
                                    if (val) {
                                      selectedStudents
                                          .add(snapshot.data[index].id);
                                    } else {
                                      selectedStudents.removeAt(index);
                                    }
                                  });
                                }),
                            onTap: () {},
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(20.0),
              elevation: 10.0,
              color: Color(0xFFebf0c2),
              child: MaterialButton(
                onPressed: () {
                  insertApi();
                  Fluttertoast.showToast(
                      msg: "Absence Bien Noté",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 18.0);
                  Navigator.pop(context);
                },
                child: Text("Ajouter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Etudiant {
  final String id;
  final String nom;
  final String prenom;
  final String email;

  Etudiant(this.id, this.nom, this.prenom, this.email);
}
