import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Gestion_Absence/Admin/GestionFil/Filiere.dart';

import 'dart:convert';

class AddStudent extends StatefulWidget {
  final String username;
  AddStudent({this.username});

  @override
  _AddStudentState createState() => _AddStudentState(username);
}

class _AddStudentState extends State<AddStudent> {
  String username;
  final format = DateFormat("yyyy-MM-dd");

  TextEditingController _nom = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _cne = TextEditingController();
  TextEditingController _cni = TextEditingController();
  TextEditingController _naissance = TextEditingController();
  List<Filiere> _filiere;

  _AddStudentState(this.username);
  String baseUrl = Api.addEtudiant;
  String url = Api.updateFil;
  String _mySelection;

  @override
  void initState() {
    super.initState();
    _filiere = [];

    _getEmployees();
  }
  // Method to update title in the AppBar Title
// Method to update title in the AppBar Title

  Future<List<Filiere>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      final response = await http.post(url, body: map);
      print('getTeachers Response: ${response.body}');
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

  _getEmployees() {
    getEmployees().then((filieres) {
      setState(() {
        _filiere = filieres;
      });
      print("Length ${filieres.length}");
    });
  }

  insertApi() async {
    await http.post(baseUrl, body: {
      'nom': _nom.text,
      'prenom': _prenom.text,
      'email': _email.text,
      'password': _password.text,
      'CNE': _cne.text,
      'CIN': _cni.text,
      'naissance': _value,
      'filiere': _mySelection
    });

    // final dataJson = jsonDecode(res.body);
    _nom.clear();
    _prenom.clear();
    _email.clear();
    _password.clear();
    _cne.clear();
    _cni.clear();
    _filiere.clear();
    _naissance.clear();
  }

  String _value = '';

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2100));
    if (picked != null)
      setState(() {
        _value = format.format(picked).toString();
        //= picked.toString();

        _naissance.value = TextEditingValue(text: _value);

        print(_value.toString());
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
                height: 30.0,
              ),
              Center(
                child: Text(
                  "Ajouter Un Etudiant",
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
                  controller: _prenom,
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
                      labelText: "Prenom",
                      hintText: "Prenom"),
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
                  controller: _nom,
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
                      labelText: "Nom",
                      hintText: "Nom"),
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
                  controller: _email,
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
                      labelText: "Email",
                      hintText: "Email"),
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
                  obscureText: true,
                  controller: _password,
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
                      labelText: "Password",
                      hintText: "Password"),
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
                  controller: _cne,
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
                      labelText: "CNE",
                      hintText: "CNE"),
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
                  controller: _cni,
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
                      labelText: "CNI",
                      hintText: "CNI"),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    _selectDate(); // Call Function that has showDatePicker()
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelStyle:
                              TextStyle(color: Colors.brown, fontSize: 18.0),
                          fillColor: Colors.brown,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.brown, width: 5.0),
                          ),
                          labelText: "Date De Naissance",
                          hintText: "Date De Naissance"),
                      controller: _naissance,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: 1,
                alignment: Alignment.center,
                padding: EdgeInsets.all(2.0),
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
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text(
                      "Filière",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.brown,
                      ),
                    ),
                    items: _filiere.map((filiere) {
                      return new DropdownMenuItem(
                        child: new Text(filiere.nomFil),
                        value: filiere.id.toString(),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelection = newVal;
                      });
                    },
                    value: _mySelection,
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
                  },
                  //color: Colors.deepOrange,
                  child: Text(
                    "Ajouter",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
