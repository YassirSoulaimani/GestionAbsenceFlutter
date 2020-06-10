import 'package:Gestion_Absence/Admin/GestionProf/Teacher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:Gestion_Absence/api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gestion_Absence/Admin/GestionFil/Filiere.dart';

import 'dart:convert';

class Anoncement extends StatefulWidget {
  final String email;

  Anoncement(this.email);
  @override
  _AnoncementState createState() => _AnoncementState(email);
}

class _AnoncementState extends State<Anoncement> {
  String email;
  _AnoncementState(this.email);
  List<Teacher> _prof;
  List<Filiere> _filiere;

  String urlProf = Api.updateTeacher;
  String url = Api.anonces;
  String urlFil = Api.pre;

  String _mySelectionA;

  @override
  void initState() {
    super.initState();
    _filiere = [];
    _prof = [];
    _getFilieres();
    _getProf();
  }

  String nomProf;
  insertApi() async {
    final response = await http.post(url, body: {
      'action': "ADD_ANNONCEMENT",
      'icon': _result,
      'titre': _titre.text,
      'description': _annonce.text,
      'nomProf': nomProf,
      'id_Fil': _mySelectionA,
    });
    print('Response: ${response.body}');

    _titre.clear();
    _annonce.clear();
  }

  String _result;
  int _radioValue;

  void _handleRadioValueChange(value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _result = "priority_high";
          _titre.text = "Examen";
          break;
        case 1:
          _result = "assignment";
          _titre.text = "Travail à Faire";
          break;
        case 2:
          _result = "do_not_disturb";
          _titre.text = "Indisponibilité";
          break;
        case 3:
          _result = "more_horiz";
          _titre.text = "";
          break;
      }
    });
  }

  Future<List<Teacher>> getProf() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_email';
      map['email'] = widget.email;
      final response = await http.post(urlProf, body: map);
      if (200 == response.statusCode) {
        List<Teacher> liste = parseProf(response.body);
        return liste;
      } else {
        return List<Teacher>();
      }
    } catch (e) {
      return List<Teacher>(); // return an empty list on exception/error
    }
  }

  static List<Teacher> parseProf(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Teacher>((json) => Teacher.fromJson(json)).toList();
  }

  _getProf() {
    getProf().then((profs) {
      setState(() {
        _prof = profs;
        nomProf = _prof[0].nom;
      });
      print("Length ${profs.length}");
    });
  }

  Future<List<Filiere>> getFilieres() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_Fil';
      map['email'] = widget.email;
      final response = await http.post(urlFil, body: map);
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

  final format = DateFormat("yyyy-MM-dd");

  TextEditingController _titre = TextEditingController();
  TextEditingController _annonce = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.brown),
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Center(
              child: ListView(shrinkWrap: true, children: <Widget>[
            SizedBox(
              height: 50.0,
            ),
            Center(
              child: Text(
                "Annonce Aux Etudiants",
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 20.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        new Radio(
                          activeColor: Colors.brown,
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text('Examen'),
                        new Radio(
                          activeColor: Colors.brown,
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text('Travail à Faire'),
                        new Radio(
                          activeColor: Colors.brown,
                          value: 2,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text('Indisponiblité'),
                        SizedBox(
                          width: 10.0,
                        ),
                        new Radio(
                          activeColor: Colors.brown,
                          value: 3,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text('Autre'),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 5,
                    height: 30.0,
                    color: Colors.brown,
                  ),
                  Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: new Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: DropdownButtonHideUnderline(
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

                              print(_mySelectionA);
                            });
                          },
                          hint: Text("Filière"),
                          value: _mySelectionA,
                        ),
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: new Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: TextField(
                      controller: _titre,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Titre"),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(10.0),
                    height: 300.0,
                    decoration: BoxDecoration(
                        border: new Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _annonce,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Description"),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  /* */
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Material(
              borderRadius: BorderRadius.circular(20.0),
              elevation: 10.0,
              color: Color(0xFFebf0c2),
              child: MaterialButton(
                onPressed: () {
                  insertApi();
                },
                //color: Colors.deepOrange,
                child: Text("Annoncer"),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
          ]))),
    );
  }
}
