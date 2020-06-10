import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';

import 'dart:convert';

class AnonceDetails extends StatefulWidget {
  final String titre;

  AnonceDetails(this.titre);
  @override
  _AnonceDetailsState createState() => _AnonceDetailsState(titre);
}

class _AnonceDetailsState extends State<AnonceDetails> {
  String titre;

  _AnonceDetailsState(this.titre);

  String text1 = '';
  String text2 = '';
  String text3 = '';

  String url = Api.anonces;

  @override
  void initState() {
    _getAnonces();
    super.initState();
  }

  List<Annonce> _annonces = [];

  Future<List<Annonce>> getAnonces() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_TITLE';
      map['titre'] = widget.titre;
      final response = await http.post(url, body: map);

      if (200 == response.statusCode) {
        List<Annonce> list = parseAnnonce(response.body);
        return list;
      } else {
        return List<Annonce>();
      }
    } catch (e) {
      return List<Annonce>(); // return an empty list on exception/error
    }
  }

  static List<Annonce> parseAnnonce(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Annonce>((json) => Annonce.fromJson(json)).toList();
  }

  _getAnonces() async {
    getAnonces().then((annonces) {
      setState(() {
        _annonces = annonces;
        text1 = _annonces[0].titre;
        text2 = _annonces[0].description;
        text3 = _annonces[0].nomProf;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.brown),
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Center(
              child: ListView(shrinkWrap: true, children: <Widget>[
            SizedBox(
              height: 50.0,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    text1 ?? 'Nom',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  Divider(
                    thickness: 3,
                    height: 20.0,
                    color: Colors.brown,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    text2 ?? '',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Professeur : " + text3 ?? '',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  )
                  /* */
                ],
              ),
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
                  Navigator.pop(context);
                },
                child: Text("Retourner"),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
          ]))),
    );
  }
}

class Annonce {
  final String icon;
  final String titre;
  final String description;
  final String nomProf;
  final String idFil;

  Annonce({this.icon, this.titre, this.description, this.nomProf, this.idFil});

  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      icon: json['icon'],
      titre: json['titre'] as String,
      description: json['description'] as String,
      nomProf: json['nomProf'] as String,
      idFil: json['idFil'] as String,
    );
  }
}
