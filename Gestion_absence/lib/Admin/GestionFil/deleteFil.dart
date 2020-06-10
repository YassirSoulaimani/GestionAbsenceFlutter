import 'package:Gestion_Absence/Admin/GestionFil/Filiere.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'dart:convert';

class DeleteFil extends StatefulWidget {
  //
  DeleteFil() : super();

  final String title = 'Flutter Data Table';

  @override
  DeleteFilState createState() => DeleteFilState();
}

class DeleteFilState extends State<DeleteFil> {
  List<Filiere> _filieres;

  String baseUrl = Api.deleteFil;

  @override
  void initState() {
    super.initState();
    _filieres = [];

    _getEmployees();
  }

  // Method to update title in the AppBar Title

  Future<List<Filiere>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      final response = await http.post(baseUrl, body: map);
      //print('getTeachers Response: ${response.body}');
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

  static List<Filiere> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Filiere>((json) => Filiere.fromJson(json)).toList();
  }

  _getEmployees() {
    getEmployees().then((teachers) {
      setState(() {
        _filieres = teachers;
      });
    });
  }

  Future<String> deleteEmployee(String id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'DELETE_EMP';
      map['id'] = id;
      final response = await http.post(baseUrl, body: map);
      print('delete Teacher Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }

  _deleteEmployee(Filiere filiere) {
    deleteEmployee(filiere.id).then((result) {
      if ('success' == result) {
        _getEmployees(); // Refresh after delete...
      }
    });
  }

  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Etiquette_Filière'),
            ),
            DataColumn(
              label: Text('Nom Filière'),
            ),

            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('Supprimer'),
            )
          ],
          rows: _filieres
              .map(
                (filiere) => DataRow(cells: [
                  DataCell(
                    Text(filiere.etiquette.toUpperCase()),
                  ),
                  DataCell(
                    Text(
                      filiere.nomFil.toUpperCase(),
                    ),
                  ),
                  DataCell(IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteEmployee(filiere);
                    },
                  ))
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F1F3),
      appBar: AppBar(
        title: Text("Supprimer Filières"),
        backgroundColor: Colors.brown, // we show the progress in the title...
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
    );
  }
}
