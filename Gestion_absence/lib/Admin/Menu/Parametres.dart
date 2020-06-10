import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';

class Parametres extends StatefulWidget {
  final String username;
  Parametres({this.username});

  @override
  _ParametresState createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  TextEditingController _password = TextEditingController();

  String msg = "";

  void editData(String username, String password) {
    String baseUrl = Api.update;

    http.post(baseUrl, body: {
      "username": username,
      "password": password,
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F1F3),
      body: Container(
        padding: EdgeInsets.only(top: 150, left: 10, right: 10),
        child: Center(
          child: ListView(
            children: <Widget>[
              Center(
                child: Text(
                  "Parametres " + widget.username,
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.brown,
                          fontSize: 32,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      hintText: "Password"),
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
                    editData(widget.username, _password.text);
                  },
                  child: Text("Changer mot de passe",
                      style: TextStyle(color: Colors.white)),
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
