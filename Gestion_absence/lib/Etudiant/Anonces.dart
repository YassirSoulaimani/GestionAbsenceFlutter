import 'package:Gestion_Absence/Etudiant/AnonceDetails.dart';
import 'package:Gestion_Absence/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:icons_helper/icons_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class Anonce extends StatefulWidget {
  final String username;

  Anonce({Key key, this.username});
  @override
  _AnonceState createState() => _AnonceState();
}

class _AnonceState extends State<Anonce> {
  //initState
  final key = GlobalKey();

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String url = Api.anonces;
  Future<List<Annonce>> _getUsers() async {
    var map = Map<String, dynamic>();
    map['action'] = 'GET_ALL';
    map['email'] = widget.username;
    var data = await http.post(url, body: map);
    var jsonData = json.decode(data.body);
    List<Annonce> annonces = [];
    for (var u in jsonData) {
      Annonce annonce = Annonce(
          u["icon"], u["titre"], u["description"], u["nomProf"], u["idFil"]);
      annonces.add(annonce);
    }
    return annonces;
  }

  List<Annonce> ann;

  @override
  void initState() {
    ann = [];
    _getModules();

    super.initState();
  }

  _getModules() {
    _getUsers().then((annonces) {
      setState(() {
        ann = annonces;
      });
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String baseUrl = Api.attendance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.brown, //change your color here
        ),
        title: new Text(
          'Annonces',
          style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  color: Colors.brown,
                  fontSize: 24,
                  fontWeight: FontWeight.w900)),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.brown),
        child: Column(
          children: <Widget>[
            Container(
              child: FutureBuilder(
                future: _getUsers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(child: Center(child: Text("Loading...")));
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: ann.length,
                      itemBuilder: (BuildContext context, int index) {
                        final anr = ann[index];
                        return Dismissible(
                          key: Key(anr.toString()),
                          onDismissed: (direction) {
                            setState(() {
                              ann.removeAt(index);
                            });
                          },
                          child: Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: ListTile(
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 2.0, color: Colors.brown))),
                                child: Icon(
                                    getIconGuessFavorMaterial(
                                        name: ann[index].icon),
                                    color: Colors.brown),
                              ),
                              title: Text(capitalize(ann[index].titre)),
                              trailing: Text(
                                  "Prof : " + capitalize(ann[index].nomProf)),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        AnonceDetails(ann[index].titre)));
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Annonce {
  final String icon;
  final String titre;
  final String description;
  final String nomProf;
  final String idFil;

  Annonce(this.icon, this.titre, this.description, this.nomProf, this.idFil);
}
