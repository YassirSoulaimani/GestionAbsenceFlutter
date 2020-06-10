import 'package:Gestion_Absence/Admin/GestionModule/Module.dart';
import 'package:flutter/material.dart';
import './editM.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'dart:convert';

class EditMod extends StatefulWidget {
  EditMod() : super();

  final String title = 'Flutter Data Table';

  @override
  EditModState createState() => EditModState();
}

class EditModState extends State<EditMod> {
  List<Module> _module;

  String baseUrl = Api.updateMod;

  @override
  void initState() {
    super.initState();
    _module = [];

    _getEmployees();
  }

  // Method to update title in the AppBar Title

  Future<List<Module>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      final response = await http.post(baseUrl, body: map);
      if (200 == response.statusCode) {
        List<Module> list = parseResponse(response.body);
        return list;
      } else {
        return List<Module>();
      }
    } catch (e) {
      return List<Module>(); // return an empty list on exception/error
    }
  }

  static List<Module> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Module>((json) => Module.fromJson(json)).toList();
  }

  _getEmployees() {
    getEmployees().then((filieres) {
      setState(() {
        _module = filieres;
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
              label: Text('Nom Module'),
            ),
            DataColumn(
              label: Text('Description'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('Editer'),
            )
          ],
          rows: _module
              .map(
                (module) => DataRow(cells: [
                  DataCell(
                    Text(module.nomModule.toUpperCase()),
                  ),
                  DataCell(
                    Text(
                      module.description.toUpperCase(),
                    ),
                  ),
                  DataCell(IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditM(
                                id: module.id,
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
      appBar: AppBar(
        title: Text("Editer Les Modules"),
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
