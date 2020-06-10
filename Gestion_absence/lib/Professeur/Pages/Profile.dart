import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:Gestion_Absence/Admin/GestionProf/Teacher.dart';

class Profile extends StatefulWidget {
  final String id;

  Profile(this.id);

  @override
  _ProfileState createState() => _ProfileState(id);
}

class _ProfileState extends State<Profile> {
  String id;
  _ProfileState(this.id);

  final format = DateFormat("yyyy-MM-dd");
  Teacher teacher;

  TextEditingController _nom = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _numTel = TextEditingController();
  TextEditingController _naissance = TextEditingController();

  int valeur = 0;
  String baseUrl = Api.updateTeacher;
  @override
  void initState() {
    print(widget.id);
    teacher = _getEmployees();
    super.initState();
  }
  // Method to update title in the AppBar Title
// Method to update title in the AppBar Title

  Future<List<Teacher>> getData() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET';
      map['id'] = widget.id;
      final response = await http.post(baseUrl, body: map);
      if (200 == response.statusCode) {
        List<Teacher> list = parseResponse(response.body);

        return list;
      } else {
        return List<Teacher>();
      }
    } catch (e) {
      return List<Teacher>(); // return an empty list on exception/error
    }
  }

  _getEmployees() {
    getData().then((teachers) {
      if (teachers.isNotEmpty) {
        setState(() {
          print(widget.id);
          _prenom.text = teachers[0].prenom;
          _nom.text = teachers[0].nom;
          _email.text = teachers[0].email;
          _password.text = teachers[0].password;
          _numTel.text = teachers[0].numTel;
          _naissance.text = teachers[0].naissance;
        });
      }
    });
  }

  static List<Teacher> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Teacher>((json) => Teacher.fromJson(json)).toList();
  }

  Future insertApi() async {
    final response = await http.post(baseUrl, body: {
      'action': "UPDATE_EMP",
      'id': widget.id,
      'nom': _nom.text,
      'prenom': _prenom.text,
      'email': _email.text,
      'password': _password.text,
      'numTel': _numTel.text,
      'naissance': _value,
    });
    print('delete Teacher Response: ${response.body}');
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
      backgroundColor: Colors.brown,
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
                  "Editez vos info",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.white,
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
                  controller: _prenom,
                  decoration: InputDecoration(
                    labelText: " Prenom",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 24.0),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 5.0),
                    ),
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
                    labelStyle: TextStyle(color: Colors.white, fontSize: 24.0),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 5.0),
                    ),
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
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 24.0),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 5.0),
                    ),
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
                    labelStyle: TextStyle(color: Colors.white, fontSize: 24.0),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 5.0),
                    ),
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
                  controller: _numTel,
                  decoration: InputDecoration(
                    labelText: "Telephone",
                    labelStyle: TextStyle(color: Colors.white, fontSize: 24.0),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 5.0),
                    ),
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
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 24.0),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 5.0),
                        ),
                      ),
                      controller: _naissance,
                    ),
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
                color: Color(0xFFebf0c2),
                child: MaterialButton(
                  onPressed: () {
                    insertApi();
                    Navigator.pop(context);
                  },
                  child: Text("Modifier"),
                ),
              ),
              SizedBox(
                height: 45.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
