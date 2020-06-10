import 'package:Gestion_Absence/Admin/GestionEtudiant/editStudent.dart';
import 'package:Gestion_Absence/Admin/GestionFil/Filiere.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'Student.dart';

class Edits extends StatefulWidget {
  final String id;
  Edits({this.id});

  @override
  _EditsState createState() => _EditsState(id);
}

class _EditsState extends State<Edits> {
  String id;
  _EditsState(this.id);

  final format = DateFormat("yyyy-MM-dd");
  Student student;

  TextEditingController _nom = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _cne = TextEditingController();
  TextEditingController _cni = TextEditingController();
  TextEditingController _naissance = TextEditingController();
  List<Filiere> _filiere;
  String _mySelectionA;

  String baseUrl = Api.updateEtudiant;
  String url = Api.updateFil;
  @override
  void initState() {
    _filiere = [];
    _getEmployees();
    _getFilieres();
    super.initState();
  }
  // Method to update title in the AppBar Title
// Method to update title in the AppBar Title

  Future<List<Filiere>> getFilieres() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      final response = await http.post(url, body: map);
      print('getTeachers Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Filiere> list = parseFil(response.body);
        return list;
      } else {
        return List<Filiere>();
      }
    } catch (e) {
      return List<Filiere>(); // return an empty list on exception/error
    }
  }

  static List<Filiere> parseFil(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Filiere>((json) => Filiere.fromJson(json)).toList();
  }

  _getFilieres() {
    getFilieres().then((filieres) {
      setState(() {
        _filiere = filieres;
      });
      print("Length ${filieres.length}");
    });
  }

  Future<List<Student>> getData() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET';
      map['id'] = widget.id;
      final response = await http.post(baseUrl, body: map);
      //print('deleteStudent Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Student> list = parseResponse(response.body);

        return list;
      } else {
        return List<Student>();
      }
    } catch (e) {
      return List<Student>(); // return an empty list on exception/error
    }
  }

  String t = '';
  String f = '';
  _getEmployees() {
    getData().then((students) {
      setState(() {
        print(students[0].prenom);
        _prenom.text = students[0].prenom;
        _nom.text = students[0].nom;
        _email.text = students[0].email;
        _password.text = students[0].password;
        _cne.text = students[0].cne;
        _cni.text = students[0].cin;
        f = students[0].filiere;
        t = students[0].naissance;
      });

      //  print("Length ${students.length}");
    });
  }

  static List<Student> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Student>((json) => Student.fromJson(json)).toList();
  }

  Future insertApi() async {
    final response = await http.post(baseUrl, body: {
      'action': "UPDATE_EMP",
      'id': widget.id,
      'nom': _nom.text,
      'prenom': _prenom.text,
      'email': _email.text,
      'password': _password.text,
      'CNE': _cne.text,
      'CIN': _cni.text,
      'naissance': _value,
      'filiere': _mySelectionA
    });
    print('deleteStudent Response: ${response.body}');
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
                  "Modification",
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
                    labelText: "Prenom",
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
                  controller: _nom,
                  decoration: InputDecoration(
                    labelText: "Nom",
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
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: "email",
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
                  obscureText: true,
                  controller: _password,
                  decoration: InputDecoration(
                    labelText: "Password",
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
                  controller: _cne,
                  decoration: InputDecoration(
                    labelText: "CNE",
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
                  controller: _cni,
                  decoration: InputDecoration(
                    labelText: "CNI",
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
                child: InkWell(
                  onTap: () {
                    _selectDate(); // Call Function that has showDatePicker()
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Date De Naissance",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      controller: _naissance,
                    ),
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
                    hint: Text(
                      "Filiere",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    value: _mySelectionA,
                  ),
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              Material(
                borderRadius: BorderRadius.circular(20.0),
                elevation: 10.0,
                color: Colors.brown,
                child: MaterialButton(
                  onPressed: () {
                    insertApi();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EditStudent()));
                  },
                  //color: Colors.deepOrange,
                  child: Text("Modifier"),
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
