import 'package:Gestion_Absence/Admin/GestionEtudiant/Student.dart';
import 'package:Gestion_Absence/Etudiant/graph2.dart';
import 'package:Gestion_Absence/Professeur/Pages/GraphEtudiant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gestion_Absence/Admin/GestionFil/Filiere.dart';

import 'dart:convert';

class PreAbs extends StatefulWidget {
  PreAbs();
  @override
  _PreAbsState createState() => _PreAbsState();
}

class _PreAbsState extends State<PreAbs> {
  _PreAbsState();

  List<Filiere> _filiere;
  List<Student> _etudiants;
  String url = Api.pre;
  String _mySelectionA;
  String _mySelectionB;
  String _mySelectionC;

  @override
  void initState() {
    super.initState();
    _filiere = [];
    _etudiants = [];
    _getFilieres();
  }
  // Method to update title in the AppBar Title
// Method to update title in the AppBar Title

  Future<List<Filiere>> getFilieres() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_Fils';
      final response = await http.post(url, body: map);
      print('get Filieres Response: ${response.body}');

      if (200 == response.statusCode) {
        List<Filiere> list = parseResponse(response.body);
        return list;
      } else {
        return List<Filiere>();
      }
    } catch (e) {
      return List<Filiere>(); // return an empty list on exception/error
    }
  }

  static List<Filiere> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Filiere>((json) => Filiere.fromJson(json)).toList();
  }

  _getFilieres() {
    getFilieres().then((filieres) {
      setState(() {
        _filiere = filieres;
      });
      //print("Length ${filieres.length}");
    });
  }

  bool _visible = false;

  Future<List<Student>> getStudents() async {
    try {
      var map = Map<String, dynamic>();

      map['action'] = 'GET_Etu';
      map['id'] = _mySelectionA;

      final response = await http.post(url, body: map);
      print('get Module Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Student> list = parseStudent(response.body);
        return list;
      } else {
        return List<Student>();
      }
    } catch (e) {
      return List<Student>(); // return an empty list on exception/error
    }
  }

  static List<Student> parseStudent(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Student>((json) => Student.fromJson(json)).toList();
  }

  _getStudents() {
    getStudents().then((etudiants) {
      setState(() {
        _etudiants = etudiants;
      });
      print("nom ${etudiants[0].nom}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.brown),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Center(
                //padding: EdgeInsets.only(top: 50, left: 130, right: 16),
                child: Text(
                  "Consulter Absence Par Fillière",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: new DropdownButton(
                  isExpanded: true,
                  items: _filiere.map((filiere) {
                    return new DropdownMenuItem(
                      child: new Text(
                        filiere.nomFil,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                          color: Colors.brown,
                          fontSize: 16,
                        )),
                      ),
                      value: filiere.id.toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      _mySelectionC = newVal;
                    });
                  },
                  hint: Text("Filière"),
                  value: _mySelectionC,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              /* */
              Material(
                borderRadius: BorderRadius.circular(20.0),
                elevation: 10.0,
                color: Color(0xFFebf0c2),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => GraphEtudiant(
                              username: _mySelectionC,
                            )));
                  },
                  //color: Colors.deepOrange,
                  child: Text("Consulter"),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Divider(
                thickness: 5,
                height: 5,
                color: Colors.white,
              ),
              SizedBox(
                height: 25.0,
              ),
              Center(
                //padding: EdgeInsets.only(top: 50, left: 130, right: 16),
                child: Text(
                  "Consulter Absence Par Etudiant",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: new DropdownButton(
                  isExpanded: true,
                  items: _filiere.map((filiere) {
                    return new DropdownMenuItem(
                      child: new Text(
                        filiere.nomFil,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                          color: Colors.brown,
                          fontSize: 16,
                        )),
                      ),
                      value: filiere.id.toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      _mySelectionA = newVal;
                      _visible = true;
                      print(_mySelectionA);
                      _getStudents();
                    });
                  },
                  hint: Text("Filière"),
                  value: _mySelectionA,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Visibility(
                visible: _visible,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: new DropdownButton(
                    isExpanded: true,
                    items: _etudiants.map((etudiants) {
                      return new DropdownMenuItem(
                        child: new Text(
                          etudiants.nom,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                            color: Colors.brown,
                            fontSize: 16,
                          )),
                        ),
                        value: etudiants.email,
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelectionB = newVal;
                      });
                    },
                    hint: Text("Etudiant"),
                    value: _mySelectionB,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              /* */
              Material(
                borderRadius: BorderRadius.circular(20.0),
                elevation: 10.0,
                color: Color(0xFFebf0c2),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Graph2(
                              username: _mySelectionB,
                            )));
                  },
                  //color: Colors.deepOrange,
                  child: Text("Consulter"),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
