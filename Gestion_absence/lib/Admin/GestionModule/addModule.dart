import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gestion_Absence/Admin/GestionFil/Filiere.dart';
import 'package:Gestion_Absence/Admin/GestionProf/Teacher.dart';
import 'dart:convert';

class AddMod extends StatefulWidget {
  final String username;
  AddMod({this.username});

  @override
  _AddModState createState() => _AddModState(username);
}

class _AddModState extends State<AddMod> {
  _AddModState(this.username);
  List<Filiere> _filiere;
  List<Teacher> _prof;
  String username;
  String _mySelectionA;
  String _mySelectionB;

  TextEditingController _nomMod = TextEditingController();
  TextEditingController _description = TextEditingController();

  String baseUrl = Api.addMod;
  String url = Api.pre;
  String urlProf = Api.updateTeacher;

  @override
  void initState() {
    super.initState();
    _filiere = [];
    _prof = [];
    _getProf();
    _getFilieres();
  }

  Future<List<Filiere>> getFilieres() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      final response = await http.post(url, body: map);
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
    });
  }

  Future<List<Teacher>> getProf() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
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
      });
      print("Length ${profs.length}");
    });
  }

  insertApi() async {
    final response = await http.post(baseUrl, body: {
      'nomModule': _nomMod.text,
      'description': _description.text,
      'id_Fil': _mySelectionA,
      'id_Prof': _mySelectionB,
    });
    print('getStudents Response: ${response.body}');

    _nomMod.clear();
    _description.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F1F3),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: Text(
                  "Ajouter Un Module",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.brown,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: TextField(
                  controller: _nomMod,
                  decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Colors.brown, fontSize: 18.0),
                      fillColor: Colors.brown,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown, width: 5.0),
                      ),
                      labelText: "Nom Module",
                      hintText: "Nom Module"),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: TextField(
                  controller: _description,
                  decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Colors.brown, fontSize: 18.0),
                      fillColor: Colors.brown,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown, width: 5.0),
                      ),
                      labelText: "Description",
                      hintText: "Description"),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 10, top: 2, bottom: 2),
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 5.0,
                      color: Colors.brown,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    isExpanded: true,
                    items: _filiere.map((filiere) {
                      return new DropdownMenuItem(
                        child: new Text(filiere.nomFil),
                        value: filiere.id.toString(),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelectionA = newVal;
                      });
                    },
                    hint: Text("Filière",
                        style: TextStyle(color: Colors.brown, fontSize: 18.0)),
                    value: _mySelectionA,
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 10, top: 2, bottom: 2),
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 5.0,
                      color: Colors.brown,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    isExpanded: true,
                    items: _prof.map((prof) {
                      return new DropdownMenuItem(
                        child: new Text(prof.nom),
                        value: prof.id,
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelectionB = newVal;
                      });
                    },
                    hint: Text("Professeur",
                        style: TextStyle(color: Colors.brown, fontSize: 18.0)),
                    value: _mySelectionB,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                borderRadius: BorderRadius.circular(20.0),
                elevation: 10.0,
                color: Colors.brown,
                child: MaterialButton(
                  onPressed: () {
                    insertApi();
                    Fluttertoast.showToast(
                        msg: "Module Ajouter",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[700],
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                  //color: Colors.deepOrange,
                  child: Text("Ajouter", style: TextStyle(color: Colors.white)),
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
