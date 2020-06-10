import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFil extends StatefulWidget {
  final String username;
  AddFil({this.username});

  @override
  _AddFilState createState() => _AddFilState(username);
}

class _AddFilState extends State<AddFil> {
  String username;

  TextEditingController _nomFil = TextEditingController();
  TextEditingController _etiquette = TextEditingController();
  TextEditingController _description = TextEditingController();

  _AddFilState(this.username);
  String baseUrl = Api.addFil;

  String msg = "";

  insertApi() async {
    final response = await http.post(baseUrl, body: {
      'nomFil': _nomFil.text,
      'etiquette': _etiquette.text,
      'description': _description.text,
    });
    print('getStudents Response: ${response.body}');

    // final dataJson = jsonDecode(res.body);
    _nomFil.clear();
    _description.clear();
    _etiquette.clear();
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
                  "Ajouter Une Filière",
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
                  controller: _nomFil,
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
                      labelText: "Nom Filière",
                      hintText: "Nom Filière"),
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
                  controller: _etiquette,
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
                      labelText: "Etiquette de la Filière",
                      hintText: "Etiquette de la Filière"),
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
                height: 15.0,
              ),
              Center(
                child: Text(msg, style: TextStyle(color: Colors.red)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
