import 'package:Gestion_Absence/Admin/GestionModule/Module.dart';
import 'package:Gestion_Absence/Admin/GestionFil/Filiere.dart';
import 'package:Gestion_Absence/Admin/GestionModule/editModule.dart';
import 'package:Gestion_Absence/Admin/GestionProf/Teacher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

class EditM extends StatefulWidget {
  final String id;
  EditM({this.id});

  @override
  _EditMState createState() => _EditMState(id);
}

class _EditMState extends State<EditM> {
  String id;
  _EditMState(this.id);

  final format = DateFormat("yyyy-MM-dd");
  Module module;

  TextEditingController _nomMod = TextEditingController();
  TextEditingController _description = TextEditingController();
  List<Filiere> _filiere;
  List<Teacher> _prof;
  String username;
  String _mySelectionA;
  String _mySelectionB;

  @override
  void initState() {
    _filiere = [];
    _prof = [];
    _getProf();
    _getFilieres();
    _getEmployees();
    super.initState();
  }

  String baseUrl = Api.updateMod;
  String urlFil = Api.updateFil;
  String urlProf = Api.updateTeacher;

  Future<List<Filiere>> getFilieres() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      final response = await http.post(urlFil, body: map);
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
    });
  }

  Future<List<Module>> getModule() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET';
      map['id_module'] = widget.id;
      final response = await http.post(baseUrl, body: map);
      if (200 == response.statusCode) {
        List<Module> list = parseModule(response.body);

        return list;
      } else {
        return List<Module>();
      }
    } catch (e) {
      return List<Module>();
    }
  }

  String s = '';

  _getEmployees() {
    getModule().then((modules) {
      setState(() {
        _nomMod.text = modules[0].nomModule;
        _description.text = modules[0].description;
      });
    });
  }

  static List<Module> parseModule(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Module>((json) => Module.fromJson(json)).toList();
  }

  Future insertApi() async {
    await http.post(baseUrl, body: {
      'action': "UPDATE_EMP",
      'id_module': widget.id,
      'nomModule': _nomMod.text,
      'description': _description.text,
      'id_Fil': _mySelectionA,
      'id_Prof': _mySelectionB,
    });
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
                height: 50.0,
              ),
              Center(
                child: Text(
                  "Modification du module",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.brown,
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
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: TextField(
                  controller: _nomMod,
                  decoration: InputDecoration(
                    labelText: "Nom du Module",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
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
                    labelText: "Description",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
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
                    hint: Text("Filière"),
                    value: _mySelectionA,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
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
                    hint: Text("Professeur"),
                    value: _mySelectionB,
                  ),
                ),
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EditMod()));
                  },
                  //color: Colors.deepOrange,
                  child:
                      Text("Modifier", style: TextStyle(color: Colors.white)),
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
