import 'package:flutter/material.dart';
import 'Student.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'dart:convert';

class DeleteSudent extends StatefulWidget {
  //
  DeleteSudent() : super();

  final String title = 'Flutter Data Table';

  @override
  DeleteSudentState createState() => DeleteSudentState();
}

class DeleteSudentState extends State<DeleteSudent> {
  List<Student> _students;

  String baseUrl = Api.deleteEtudiant;

  @override
  void initState() {
    super.initState();
    _students = [];

    _getEmployees();
  }

  // Method to update title in the AppBar Title

  Future<List<Student>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      final response = await http.post(baseUrl, body: map);
      print('getStudents Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Student> list = parseResponse(response.body);
        return list;
      } else {
        return List<Student>();
      }
    } catch (e) {
      return List<Student>(); // return an empty list on exception/error
    }
  }

  static List<Student> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Student>((json) => Student.fromJson(json)).toList();
  }

  _getEmployees() {
    getEmployees().then((students) {
      setState(() {
        _students = students;
      });
      print("Length ${students.length}");
    });
  }

  Future<String> deleteEmployee(String email) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'DELETE_EMP';
      map['email'] = email;
      final response = await http.post(baseUrl, body: map);
      print('deleteStudent Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }

  _deleteEmployee(Student student) {
    deleteEmployee(student.email).then((result) {
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
              label: Text('Nom'),
            ),
            DataColumn(
              label: Text('Prenom'),
            ),
            DataColumn(
              label: Text('Email'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('Supprimer'),
            )
          ],
          rows: _students
              .map(
                (student) => DataRow(cells: [
                  DataCell(
                    Text(student.nom.toUpperCase()),
                  ),
                  DataCell(
                    Text(
                      student.prenom.toUpperCase(),
                    ),
                  ),
                  DataCell(
                    Text(
                      student.email,
                    ),
                  ),
                  DataCell(IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteEmployee(student);
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
        title: Text("Supprimer Etudiants"),
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
