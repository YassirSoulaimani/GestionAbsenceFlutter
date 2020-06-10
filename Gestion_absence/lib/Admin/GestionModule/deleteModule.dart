import 'package:Gestion_Absence/Admin/GestionModule/Module.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'dart:convert';

class DeleteMod extends StatefulWidget {
  //
  DeleteMod() : super();

  final String title = 'Flutter Data Table';

  @override
  DeleteModState createState() => DeleteModState();
}

class DeleteModState extends State<DeleteMod> {
  List<Module> _modules;

  String baseUrl = Api.deleteMod;

  @override
  void initState() {
    super.initState();
    _modules = [];

    _getEmployees();
  }

  // Method to update title in the AppBar Title

  Future<List<Module>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      final response = await http.post(baseUrl, body: map);
      //print('getTeachers Response: ${response.body}');
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
    getEmployees().then((teachers) {
      setState(() {
        _modules = teachers;
      });
      print("Length ${teachers.length}");
    });
  }

  Future<String> deleteEmployee(String id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'DELETE_EMP';
      map['id_module'] = id;
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

  _deleteEmployee(Module module) {
    deleteEmployee(module.id).then((result) {
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
              label: Text('id_Module'),
            ),
            DataColumn(
              label: Text('Nom Module'),
            ),

            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('Supprimer'),
            )
          ],
          rows: _modules
              .map(
                (module) => DataRow(cells: [
                  DataCell(
                    Text(module.id),
                  ),
                  DataCell(
                    Text(
                      module.nomModule.toUpperCase(),
                    ),
                  ),
                  DataCell(IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteEmployee(module);
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
        title: Text("Supprimer Modules"),
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
