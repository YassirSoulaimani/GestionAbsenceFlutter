import 'package:Gestion_Absence/Animation/FadeAnimation.dart';
import 'package:Gestion_Absence/Etudiant/studentMenu.dart';
import 'package:Gestion_Absence/Professeur/profDashboard.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:Gestion_Absence/Admin/Menu/MenuAdmin.dart';
import './api.dart';
import 'package:http/http.dart' as http;

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  enablePlatformOverrideForDesktop();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Login Local Server",
    home: Login(),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String apiUrl = Api.url;

  String msgError = "";

  getApi(String username, String password) async {
    final res = await http
        .post(apiUrl, body: {"email": username, "password": password});
    final data = jsonDecode(res.body);

    if (data['level'] == "Admin") {
      print(data['msg'] + " dan status : " + data['level']);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MenuAdmin(username: data['email'])));
      _username.clear();
      _password.clear();
      setState(() {
        msgError = "";
      });
    } else if (data['level'] == "Professeur") {
      print(data['msg'] + " dan status : " + data['level']);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfDashboard(username: data['email'])));
      _username.clear();
      _password.clear();
      setState(() {
        msgError = "";
      });
    } else if (data['level'] == "Student") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StudentMenu(username: data['email'])));
      _username.clear();
      _password.clear();
      setState(() {
        msgError = "";
      });
    } /*else if (_username.text.isEmpty && _password.text.isEmpty) {
      setState(() {
        msgError = "Veuillez Remplire Les Champs";
      });
    }*/
    else {
      setState(() {
        msgError = "Mot de passe INCORRECT";
      });
    }
  }

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffF1F1F3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 200,
            child: Stack(
              children: <Widget>[
                Positioned(
                    child: FadeAnimation(
                  1,
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/1.png"),
                      ),
                    ),
                  ),
                ))
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FadeAnimation(
                  1,
                  SizedBox(
                    child: TypewriterAnimatedTextKit(
                      repeatForever: true,
                      text: [
                        "Bienvenue à",
                        "La Platforme d'absences",
                        "EST Essaouira",
                      ],
                      textStyle: TextStyle(
                        fontSize: 25,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                FadeAnimation(
                  1,
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.brown,
                              ),
                            ),
                          ),
                          child: TextField(
                            style: TextStyle(color: Colors.blue),
                            controller: _username,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person, color: Colors.brown),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              hintText: "Username",
                              hintStyle: TextStyle(color: Colors.brown),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: TextField(
                            style: TextStyle(color: Colors.blue),
                            controller: _password,
                            obscureText: true,
                            decoration: InputDecoration(
                                icon: Icon(Icons.vpn_key, color: Colors.brown),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.brown)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                FadeAnimation(
                  1,
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        color: Colors.brown,
                        onPressed: () {
                          getApi(_username.text, _password.text);
                        },
                        child: Text('Se Connecter',
                            style: TextStyle(color: Colors.white)),
                      )),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FadeAnimation(
                  1,
                  Center(
                    child: Text(
                      msgError,
                      style: TextStyle(
                        color: Colors.pink[200],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
