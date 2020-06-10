import 'package:Gestion_Absence/Admin/GestionEtudiant/Student.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'dart:convert';

class Attendance extends StatefulWidget {
  final String filiere;
  Attendance({this.filiere});

  @override
  _AttendanceState createState() => _AttendanceState(filiere);
}

class _AttendanceState extends State<Attendance> {
  List<Student> _students;
  _AttendanceState(filiere);
  String baseUrl = Api.attendance;
  List<Student> selectedStudents;

  @override
  void initState() {
    super.initState();
    _students = [];
    print(widget.filiere);
    _getEmployees();
  }

  Future<List<Student>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      map['id'] = widget.filiere;
      final response = await http.post(baseUrl, body: map);
      print('getTeachers Response: ${response.body}');
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
    getEmployees().then((teachers) {
      setState(() {
        _students = teachers;
      });
      //print("Length ${teachers.length}");
    });
  }

  Color _iconColor = Colors.black;

  List<String> radioValues = [];

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

            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('Supprimer'),
            ),
          ],
          rows: _students
              .map(
                (teacher) => DataRow(cells: [
                  DataCell(
                    Text(teacher.nom.toUpperCase()),
                  ),
                  DataCell(
                    Text(
                      teacher.prenom.toUpperCase(),
                    ),
                  ),
                  DataCell(IconButton(
                    icon: Icon(Icons.delete, color: _iconColor),
                    onPressed: () {
                      setState(() {
                        _iconColor = Colors.yellow;
                      });
                    },
                  )),
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
