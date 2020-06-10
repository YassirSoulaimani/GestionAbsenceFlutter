import 'package:Gestion_Absence/Admin/GestionEtudiant/Student.dart';
import 'package:Gestion_Absence/Etudiant/Absence.dart';
import 'package:Gestion_Absence/api.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Graph2 extends StatefulWidget {
  final String username;
  Graph2({this.username});

  @override
  _Graph2State createState() => _Graph2State(username);
}

class _Graph2State extends State<Graph2> {
  @override
  void initState() {
    _absences = [];
    dataMap.putIfAbsent('0', () => 0);
    modulese = [];
    dataJSON = [];
    _getEmployees();
    _getModules();
    _get();
    _getStudents();
    super.initState();
    _getMod();
  }

  final String username;
  _Graph2State(this.username);
  String baseUrl = Api.absenceEtudiant;
  String url =
      "http://yassirtestflutter.000webhostapp.com/flutter_login/Attendance/weekReport.php";
  List dataJSON;

  getCoinsTimeSeries() async {
    var map = Map<String, dynamic>();
    map['email'] = widget.username;
    final response = await http.post(url, body: map);
    List leist;

    if (response.statusCode == 200) {
      leist = json.decode(response.body) as List;
      //print(response.body);
      return leist;
    } else {
      throw Exception('Failed to load data');
    }
  }

  String baseStudent = Api.updateEtudiant;

  Future<List<Student>> getData() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_EMAIL';
      map['email'] = widget.username;
      final response = await http.post(baseStudent, body: map);
      //print('deleteStudent Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Student> list = parseStudent(response.body);

        return list;
      } else {
        return List<Student>();
      }
    } catch (e) {
      return List<Student>(); // return an empty list on exception/error
    }
  }

  static List<Student> parseStudent(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Student>((json) => Student.fromJson(json)).toList();
  }

  String name;

  _getStudents() {
    getData().then((students) {
      setState(() {
        name = students[0].nom;
      });

      //  print("Length ${students.length}");
    });
  }

  Future _getMod() async {
    getCoinsTimeSeries().then((modules) {
      dataJSON = modules;
      if (dataJSON.isNotEmpty) {
        toggle2 = true;
      }
      for (int i = 0; dataJSON.length > i; i++) {
        if (dataJSON[i]['day'] == 'Monday') {
          data.removeWhere((item) => item.day == 'Lun');
          data.add(
              new TimeSeriesSales("Lun", int.parse(dataJSON[i]['absencefil'])));
        }
      }

      for (int i = 0; dataJSON.length > i; i++) {
        if (dataJSON[i]['day'] == 'Tuesday') {
          data.removeWhere((item) => item.day == 'Mar');
          data.add(
              new TimeSeriesSales("Mar", int.parse(dataJSON[i]['absencefil'])));
          break;
        } else {
          data.add(new TimeSeriesSales("Mar", 0));
        }
      }

      for (int i = 0; dataJSON.length > i; i++) {
        if (dataJSON[i]['day'] == 'Wednesday') {
          data.removeWhere((item) => item.day == 'Mar');
          data.add(
              new TimeSeriesSales("Mer", int.parse(dataJSON[i]['absencefil'])));
          break;
        } else {
          data.add(new TimeSeriesSales("Mer", 0));
        }
      }
      for (int i = 0; dataJSON.length > i; i++) {
        if (dataJSON[i]['day'] == 'Thursday') {
          data.removeWhere((item) => item.day == 'Jeu');
          data.add(
              new TimeSeriesSales("Jeu", int.parse(dataJSON[i]['absencefil'])));
          break;
        } else {
          data.add(new TimeSeriesSales("Jeu", 0));
        }
      }

      for (int i = 0; dataJSON.length > i; i++) {
        if (dataJSON[i]['day'] == "Friday") {
          data.removeWhere((item) => item.day == 'Ven');
          print(int.parse(dataJSON[i]['absencefil']));

          data.add(
              new TimeSeriesSales("Ven", int.parse(dataJSON[i]['absencefil'])));
          break;
        } else {
          data.add(new TimeSeriesSales("Ven", 0));
        }
      }
      for (int i = 0; dataJSON.length > i; i++) {
        if (dataJSON[i]['day'] == 'Saturday') {
          data.removeWhere((item) => item.day == 'Sam');
          data.add(
              new TimeSeriesSales("Sam", int.parse(dataJSON[i]['absencefil'])));
          break;
        } else {
          data.add(new TimeSeriesSales("Sam", 0));
        }
      }
      for (int i = 0; dataJSON.length > i; i++) {
        if (dataJSON[i]['day'] == "Sunday") {
          data.removeWhere((item) => item.day == 'Dim');

          data.add(
              new TimeSeriesSales("Dim", int.parse(dataJSON[i]['absencefil'])));
          break;
        } else {
          data.add(new TimeSeriesSales("Dim", 0));
        }
      }
    });
    setState(() {
      dataRef = data;
    });
  }

  List<Absence> _absences;
  Future<List<Absence>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_Fil';
      map['email'] = widget.username;
      final response = await http.post(
          "http://yassirtestflutter.000webhostapp.com/flutter_login/Attendance/EtudiantAbsence.php",
          body: map);
      if (200 == response.statusCode) {
        List<Absence> list = parseResponse(response.body);
        return list;
      } else {
        return List<Absence>();
      }
    } catch (e) {
      return List<Absence>(); // return an empty list on exception/error
    }
  }

  static List<Absence> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Absence>((json) => Absence.fromJson(json)).toList();
  }

  _getEmployees() {
    getEmployees().then((absences) {
      setState(() {
        _absences = absences;
      });
    });
  }

  _get() {
    getModules().then((modules) {
      print(modules);
      if (modules.length != 0) {
        setState(() {
          dataMap.remove('0');
          for (int i = 0; modules.length > i; i++)
            dataMap.putIfAbsent(modules[i]['nomModule'],
                () => double.parse(modules[i]['absencefil']));
        });
        toggle = true;
      } else {
        dataMap.putIfAbsent('1', () => 0);
      }
    });
  }

  List<TimeSeriesSales> data = [];
  List<TimeSeriesSales> dataRef = [];
  getModules() async {
    var map = Map<String, dynamic>();
    List leist;
    map['action'] = 'GET_Module';
    map['email'] = widget.username;
    final response = await http.post(
        "http://yassirtestflutter.000webhostapp.com/flutter_login/Attendance/EtudiantAbsence.php",
        body: map);
    if (response.statusCode == 200) {
      leist = json.decode(response.body) as List;
    } else {
      throw Exception('Failed to load photos');
    }
    return leist;
  }

  List modulese;

  _getModules() {
    getModules().then((modules) {
      setState(() {
        modulese = modules;
      });
    });
  }

  nombreHeur() {
    var total = _absences.length * 2;
    return total.toString();
  }

  Material myTextItems(String title, String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(
                        child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool toggle = false;
  bool toggle2 = false;
  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];
  Material myCircularItems(String title) {
    return Material(
      elevation: 14.0,
      color: Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
          child: Padding(
        padding: EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            toggle
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      PieChart(
                        dataMap: dataMap,
                        animationDuration: Duration(milliseconds: 800),
                        chartLegendSpacing: 32.0,
                        chartRadius: MediaQuery.of(context).size.width / 2.7,
                        showChartValuesInPercentage: false,
                        showChartValues: true,
                        showChartValuesOutside: false,
                        chartValueBackgroundColor: Colors.grey[200],
                        colorList: colorList,
                        showLegends: true,
                        legendPosition: LegendPosition.right,
                        decimalPlaces: 0,
                        showChartValueLabel: true,
                        initialAngle: 0,
                        chartValueStyle: defaultChartValueStyle.copyWith(
                          color: Colors.blueGrey[900].withOpacity(0.9),
                        ),
                        chartType: ChartType.disc,
                      )
                    ],
                  )
                : Center(child: Text("0 Absence")),
          ],
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var series = [
      new charts.Series<TimeSeriesSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.day,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: dataRef,
      )
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
    );

    var chartWidget = new Material(
        color: Colors.white,
        elevation: 14.0,
        borderRadius: BorderRadius.circular(24.0),
        shadowColor: Color(0x802196F3),
        child: Container(
          child: toggle2
              ? chart
              : Center(child: Text("0 absence dernier semaine")),
        ));

    return Scaffold(
      body: Container(
        color: Colors.brown,
        child: StaggeredGridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 15.0),
              child: myTextItems("Etudiant", name ?? 'Loading'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 15.0),
              child: myTextItems("Total d'heurs ", nombreHeur()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: chartWidget,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: myCircularItems("Absence par Filière "),
            ),

            /*  Padding(
              padding: const EdgeInsets.all(8.0),
              child: mychart2Items("Conversion", "0.9M", "+19% of target"),
            ),*/
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 120.0),
            StaggeredTile.extent(2, 120.0),
            StaggeredTile.extent(4, 350.0),
            StaggeredTile.extent(4, 350.0),
          ],
        ),
      ),
    );
  }
}

class TimeSeriesSales {
  final String day;
  final int sales;

  TimeSeriesSales(this.day, this.sales);
}
