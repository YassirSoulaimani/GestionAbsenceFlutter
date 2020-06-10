import 'package:Gestion_Absence/Admin/GestionModule/Module.dart';
import 'package:Gestion_Absence/Professeur/Pages/list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:Gestion_Absence/api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gestion_Absence/Admin/GestionFil/Filiere.dart';

import 'dart:convert';

class PreAttendance extends StatefulWidget {
  final String email;

  PreAttendance(this.email);
  @override
  _PreAttendanceState createState() => _PreAttendanceState(email);
}

class _PreAttendanceState extends State<PreAttendance> {
  String email;
  _PreAttendanceState(this.email);

  List<Filiere> _filiere;
  List<Module> _modules;
  String url = Api.pre;
  String _mySelectionA;
  String _mySelectionB;

  @override
  void initState() {
    super.initState();
    _filiere = [];
    _modules = [];
    _naissance.text = format.format(DateTime.now()).toString();
    _getFilieres();
  }
  // Method to update title in the AppBar Title
// Method to update title in the AppBar Title

  Future<List<Filiere>> getFilieres() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_Fil';
      map['email'] = widget.email;
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
  bool _visible2 = false;

  Future<List<Module>> getModules() async {
    try {
      var map = Map<String, dynamic>();

      map['action'] = 'GET_Mod';
      map['email'] = widget.email;
      map['id'] = _mySelectionA;

      final response = await http.post(url, body: map);
      print('get Module Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Module> list = parseModule(response.body);
        return list;
      } else {
        return List<Module>();
      }
    } catch (e) {
      return List<Module>(); // return an empty list on exception/error
    }
  }

  static List<Module> parseModule(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Module>((json) => Module.fromJson(json)).toList();
  }

  _getModules() {
    getModules().then((modules) {
      setState(() {
        _modules = modules;
      });
      print("Prof ${modules[0].nomModule}");
    });
  }

  TextEditingController _naissance = TextEditingController();

  final format = DateFormat("yyyy-MM-dd");
  String _value = '';

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2010),
        lastDate: new DateTime(2025));
    if (picked != null)
      setState(() {
        _value = format.format(picked).toString();
        //= picked.toString();

        _naissance.value = TextEditingValue(text: _value);

        print(_value.toString());
      });
  }

  static const items = <String>["8:00", "10:00", "14:00", "16:00"];

  List<DropdownMenuItem<String>> _myitems = items
      .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ))
      .toList();

  String valueItem = "8:00";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.brown),
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Center(
                child: Text(
                  "Selectioner Filiere",
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
                      _getModules();
                    });
                  },
                  hint: Text("Filière"),
                  value: _mySelectionA,
                ),
              ),
              Visibility(
                child: SizedBox(
                  height: 20.0,
                ),
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
                    items: _modules.map((module) {
                      return new DropdownMenuItem(
                        child: new Text(
                          module.nomModule,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                            color: Colors.brown,
                            fontSize: 16,
                          )),
                        ),
                        value: module.id.toString(),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelectionB = newVal;
                        _visible2 = true;
                      });
                    },
                    hint: Text("Module"),
                    value: _mySelectionB,
                  ),
                ),
              ),
              Visibility(
                visible: _visible2,
                child: SizedBox(
                  height: 20.0,
                ),
              ),
              Visibility(
                visible: _visible2,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: new InkWell(
                    onTap: () {
                      _selectDate(); // Call Function that has showDatePicker()
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: _naissance,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _visible2,
                child: SizedBox(
                  height: 20.0,
                ),
              ),
              Visibility(
                visible: _visible2,
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: DropdownButton(
                      isExpanded: true,
                      hint: Text("Heure"),
                      items: _myitems,
                      value: valueItem,
                      onChanged: (e) {
                        setState(() {
                          valueItem = e;
                        });
                      },
                    )),
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
                        builder: (BuildContext context) => Liste(
                            filiere: _mySelectionA,
                            module: _mySelectionB,
                            date: _naissance.text,
                            heur: valueItem)));
                  },
                  //color: Colors.deepOrange,
                  child: Text("Ajouter"),
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
