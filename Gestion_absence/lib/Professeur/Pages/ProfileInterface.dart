import 'package:Gestion_Absence/Admin/GestionProf/Teacher.dart';
import 'package:Gestion_Absence/Professeur/Pages/Profile.dart';
import 'package:Gestion_Absence/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final String email;

  ProfileScreen(this.email);
  @override
  _ProfileScreenState createState() => _ProfileScreenState(email);
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    _getProfs();
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String text1;
  String text2;
  final String email;
  List<Teacher> _profs = [];
  String baseUrl = Api.updateTeacher;
  _ProfileScreenState(this.email);

  Future<List<Teacher>> getProf() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_email';
      map['email'] = widget.email;

      final response = await http.post(baseUrl, body: map);
      print('get teacher Response: ${response.body}');

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

  static List<Teacher> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Teacher>((json) => Teacher.fromJson(json)).toList();
  }

  String s = '';
  _getProfs() {
    getProf().then((profs) {
      setState(() {
        _profs = profs;
        text1 = profs[0].nom + ' ' + profs[0].prenom;
        s = profs[0].email;
      });
      print("Length ${profs.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.brown,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 100.0,
                backgroundImage: AssetImage(
                  "assets/social.png",
                ),
                backgroundColor: Colors.brown[200],
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                text1 ?? 'Nom',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Pacifico',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Enseignant'.toUpperCase(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'SourceSansPro',
                  color: Colors.brown.shade100,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5,
                ),
              ),
              SizedBox(
                height: 20.0,
                width: 150,
                child: Divider(
                  color: Colors.brown.shade100,
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
              InkWell(
                  child: Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Colors.brown,
                      ),
                      title: Text(
                        'Changer Les Informations',
                        style: TextStyle(
                            fontFamily: 'SourceSansPro',
                            fontSize: 20,
                            color: Colors.brown.shade900),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Profile(_profs[0].id)));
                  }),
              InkWell(
                child: Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.brown,
                    ),
                    title: Text(
                      s,
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 20,
                          color: Colors.brown.shade900),
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
