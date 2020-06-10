import 'package:Gestion_Absence/Admin/GestionFil/Filiere.dart';
import 'package:flutter/material.dart';
import './editF.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'dart:convert';

class EditFil extends StatefulWidget {
  EditFil() : super();

  final String title = 'Flutter Data Table';

  @override
  EditFilState createState() => EditFilState();
}

class EditFilState extends State<EditFil> {
  List<Filiere> _filiere;

  String baseUrl = Api.updateFil;

  @override
  void initState() {
    super.initState();
    _filiere = [];

    _getEmployees();
  }

  // Method to update title in the AppBar Title

  Future<List<Filiere>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
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

  static List<Filiere> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Filiere>((json) => Filiere.fromJson(json)).toList();
  }

  _getEmployees() {
    getEmployees().then((filieres) {
      setState(() {
        _filiere = filieres;
      });
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
              label: Text('Etiquette Filière'),
            ),
            DataColumn(
              label: Text('Nom Filiere'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('Editer'),
            )
          ],
          rows: _filiere
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
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditT(
                                id: filiere.id,
                              )));
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
        title: Text("Editer les filieres"),
        backgroundColor: Colors.brown, // we show the progress in the title...
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(),
          Expanded(
            child: _dataBody(),
          ),
        ],
      ),
    );
  }
}
