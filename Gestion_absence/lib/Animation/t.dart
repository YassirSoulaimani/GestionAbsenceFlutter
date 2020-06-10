/*import 'package:Gestion_Absence/Etudiant/Menus/Graph.dart';
import 'package:Gestion_Absence/Professeur/profDashboard.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

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
 // String apiUrl = Api.url;

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
          builder: (context) => Graph(username: data['email'])));
      _username.clear();
      _password.clear();
      setState(() {
        msgError = "";
      });
    } else {
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
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  // color: Colors.blue,
                  borderRadius: BorderRadius.circular(10.0)),
              child: TextField(
                controller: _username,
                decoration: InputDecoration(
                    hintText: 'Email',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0))),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
              child: TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Password"),
              ),
            ),
            Container(
              child: Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: () {
                      getApi(_username.text, _password.text);
                    },
                    padding: EdgeInsets.all(12),
                    color: Colors.lightBlueAccent,
                    child: Text('Se Connecter',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ]),
            ),
            Center(
              child: Text(msgError, style: TextStyle(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}
*/
