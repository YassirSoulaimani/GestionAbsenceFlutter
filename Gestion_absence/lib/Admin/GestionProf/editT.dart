import 'package:Gestion_Absence/Admin/GestionProf/editTeacher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'Teacher.dart';

class EditT extends StatefulWidget {
  final String id;
  EditT({this.id});

  @override
  _EditTState createState() => _EditTState(id);
}

class _EditTState extends State<EditT> {
  String id;
  _EditTState(this.id);

  final format = DateFormat("yyyy-MM-dd");
  Teacher teacher;

  TextEditingController _nom = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _numTel = TextEditingController();
  TextEditingController _naissance = TextEditingController();

  String baseUrl = Api.updateTeacher;

  @override
  void initState() {
    getData();
    _getEmployees();
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
      setState(() {
        print(teachers[0].prenom);
        _prenom.text = teachers[0].prenom;
        _nom.text = teachers[0].nom;
        _email.text = teachers[0].email;
        _password.text = teachers[0].password;
        _numTel.text = teachers[0].numTel;
        _naissance.text = teachers[0].naissance;
      });
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
        firstDate: new DateTime(1970),
        lastDate: new DateTime(2030));
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
                height: 50.0,
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
                  controller: _numTel,
                  decoration: InputDecoration(
                    labelText: "Telephone",
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
                        labelText: "Date de naissance",
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
                        MaterialPageRoute(builder: (context) => EditTeacher()));
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
