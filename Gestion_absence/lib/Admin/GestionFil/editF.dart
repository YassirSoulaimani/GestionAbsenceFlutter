import 'package:Gestion_Absence/Admin/GestionFil/Filiere.dart';
import 'package:Gestion_Absence/Admin/GestionFil/editFil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

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
  Filiere filiere;

  TextEditingController _nomFil = TextEditingController();
  TextEditingController _etiquette = TextEditingController();
  TextEditingController _description = TextEditingController();

  String baseUrl = Api.updateFil;

  @override
  void initState() {
    getData();
    _getEmployees();
    super.initState();
  }
  // Method to update title in the AppBar Title
// Method to update title in the AppBar Title

  Future<List<Filiere>> getData() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET';
      map['id'] = widget.id;
      final response = await http.post(baseUrl, body: map);
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

  _getEmployees() {
    getData().then((filieres) {
      setState(() {
        print(widget.id);
        _nomFil.text = filieres[0].nomFil;
        _etiquette.text = filieres[0].etiquette;
        _description.text = filieres[0].description;
      });
    });
  }

  static List<Filiere> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Filiere>((json) => Filiere.fromJson(json)).toList();
  }

  Future insertApi() async {
    final response = await http.post(baseUrl, body: {
      'action': "UPDATE_EMP",
      'id': widget.id,
      'etiquette': _etiquette.text,
      'nomFil': _nomFil.text,
      'description': _description.text,
    });
    print('Update Filiere Response: ${response.body}');
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
                    labelText: "Nom de la Filière",
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
                  controller: _etiquette,
                  decoration: InputDecoration(
                    labelText: "Etiquette de la Filière",
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
                        MaterialPageRoute(builder: (context) => EditFil()));
                  },
                  //color: Colors.deepOrange,
                  child: Text(
                    "Modifier",
                    style: TextStyle(color: Colors.white),
                  ),
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
