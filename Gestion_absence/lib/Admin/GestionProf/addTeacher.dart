import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTeacher extends StatefulWidget {
  final String username;
  AddTeacher({this.username});

  @override
  _AddTeacherState createState() => _AddTeacherState(username);
}

class _AddTeacherState extends State<AddTeacher> {
  String username;
  final format = DateFormat("yyyy-MM-dd");

  TextEditingController _nom = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _numTel = TextEditingController();
  TextEditingController _naissance = TextEditingController();

  _AddTeacherState(this.username);
  String baseUrl = Api.addTeacher;

  String msg = "";

  insertApi() async {
    final response = await http.post(baseUrl, body: {
      'nom': _nom.text,
      'prenom': _prenom.text,
      'email': _email.text,
      'password': _password.text,
      'numTel': _numTel.text,
      'naissance': _value,
    });
    print('getStudents Response: ${response.body}');

    // final dataJson = jsonDecode(res.body);
    _nom.clear();
    _prenom.clear();
    _email.clear();
    _password.clear();
    _numTel.clear();
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
                height: 50.0,
              ),
              Center(
                child: Text(
                  "Ajouter Un Professeur",
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
                      border: OutlineInputBorder(),
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
                      border: OutlineInputBorder(),
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
                      border: OutlineInputBorder(),
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
                  //obscureText: true,
                  controller: _password,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
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
                  controller: _numTel,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Telephone",
                      hintText: "Telephone"),
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
                          border: OutlineInputBorder(),
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
