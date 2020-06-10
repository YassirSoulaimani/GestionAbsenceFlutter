import 'package:flutter/material.dart';
import 'Teacher.dart';
import './editT.dart';
import 'package:http/http.dart' as http;
import 'package:Gestion_Absence/api.dart';
import 'dart:convert';

class EditTeacher extends StatefulWidget {
  EditTeacher() : super();

  @override
  EditTeacherState createState() => EditTeacherState();
}

class EditTeacherState extends State<EditTeacher> {
  List<Teacher> _teachers;
  String baseUrl = Api.updateTeacher;

  @override
  void initState() {
    super.initState();
    _teachers = [];

    _getEmployees();
  }

  // Method to update title in the AppBar Title

  Future<List<Teacher>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ALL';
      final response = await http.post(baseUrl, body: map);
      print('getTeachers Response: ${response.body}');
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

  _getEmployees() {
    getEmployees().then((teachers) {
      setState(() {
        _teachers = teachers;
      });
      print("Length ${teachers.length}");
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
              label: Text('Modifier'),
            )
          ],
          rows: _teachers
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
                  DataCell(
                    Text(
                      teacher.email,
                    ),
                  ),
                  DataCell(IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditT(
                                id: teacher.id,
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
        title: Text("Editer Enseignants"),
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
