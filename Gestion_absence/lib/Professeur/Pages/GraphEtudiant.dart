import 'package:Gestion_Absence/api.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GraphEtudiant extends StatefulWidget {
  final String username;
  GraphEtudiant({this.username});

  @override
  _GraphEtudiantState createState() => _GraphEtudiantState(username);
}

class _GraphEtudiantState extends State<GraphEtudiant> {
  @override
  void initState() {
    _absences = [];
    dataMap.putIfAbsent('0', () => 0);
    modulese = [];
    dataJSON = [];

    _getModules();
    _getFilieres();
    _get();

    super.initState();
  }

  final String username;
  _GraphEtudiantState(this.username);
  String baseUrl = Api.absenceEtudiant;
  String baseStudent = Api.updateEtudiant;

  String url =
      "http://yassirtestflutter.000webhostapp.com/flutter_login/Attendance/Etudiantmo.php";
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

  String text1 = "";
  String text2 = "";

  /*uture<List<Student>> getData() async {
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
  }*/

  /*_getMod() {
    getCoinsTimeSeries().then((modules) {
      dataJSON = modules;
    });
  }*/

  List _absences;
  getFil() async {
    var map = Map<String, dynamic>();
    List leist;
    map['action'] = 'GET_FilHeur';
    map['id'] = widget.username;
    final response = await http.post(baseUrl, body: map);
    if (response.statusCode == 200) {
      leist = json.decode(response.body) as List;
    } else {
      toggle = false;
    }
    return leist;
  }

  _getFilieres() {
    getFil().then((absences) {
      setState(() {
        text1 = absences[0]['absencefil'];
        print(text1);
        text2 = absences[0]['nomFil'];
        _absences = absences;
      });
    });
  }

  _get() {
    getModules().then((modules) {
      setState(() {
        dataMap.remove('0');
        for (int i = 0; modules.length > i; i++)
          dataMap.putIfAbsent(modules[i]['nomModule'],
              () => double.parse(modules[i]['absencefil']));

        if (dataMap.isEmpty) {
          toggle = false;
        } else {
          toggle = true;
        }
      });
    });
  }

  List<TimeSeriesSales> data = [];

  getModules() async {
    var map = Map<String, dynamic>();
    List leist;
    map['action'] = 'GET_ModFil';
    map['id'] = widget.username;
    final response = await http.post(baseUrl, body: map);
    if (response.statusCode == 200) {
      leist = json.decode(response.body) as List;
    } else {
      toggle = false;
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
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material myTextItems2(String title, String subtitle) {
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
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
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
            Column(
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
                toggle
                    ? PieChart(
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
                    : Center(child: Text("Aucune Absence")),
              ],
            )
          ],
        ),
      )),
    );
  }

  bool toggle2 = false;

  @override
  Widget build(BuildContext context) {
    /* for (int i = 0; dataJSON.length > i; i++) {
      data.add(TimeSeriesSales(DateTime.parse(dataJSON[i]['date']),
          int.parse(dataJSON[i]['absencefil'])));

      // Dummy list to prevent dataJSON = NULL
      //data.add(new TimeSeriesSales(new DateTime.now(), 0));
    }

    if (data.isEmpty) {
      toggle2 = false;
    } else {
      toggle2 = true;
    }

    var series = [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];

    var chart = new charts.TimeSeriesChart(
      series,
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      animate: true,
      behaviors: [
        charts.SlidingViewport(),
        charts.PanAndZoomBehavior(),
      ],
      domainAxis: charts.DateTimeAxisSpec(
        tickProviderSpec: charts.DayTickProviderSpec(increments: [2]),
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day: charts.TimeFormatterSpec(
            format: 'dd',
            transitionFormat: 'dd',
          ),
        ),
      ),
    );

    var chartWidget = new Material(
        color: Colors.white,
        elevation: 14.0,
        borderRadius: BorderRadius.circular(24.0),
        shadowColor: Color(0x802196F3),
        child: Center(
            child: Padding(
          padding: EdgeInsets.all(30.0),
          child: toggle2
              ? chart
              : Text(
                  "Aucune Absence",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
        )));*/

    return Scaffold(
      body: Container(
        color: Colors.brown,
        child: StaggeredGridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: myTextItems2("Filière", text2 ?? "dzdz"),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: myTextItems("Total d'heurs ", text1 ?? "dzdz"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: myCircularItems("Absences Modules "),
            ),
            /*  Padding(
              padding: const EdgeInsets.all(8.0),
              child: mychart2Items("Conversion", "0.9M", "+19% of target"),
            ),*/
          ],
          staggeredTiles: [
            StaggeredTile.extent(4, 15.0),
            StaggeredTile.extent(4, 120.0),
            StaggeredTile.extent(4, 120.0),
            StaggeredTile.extent(4, 350.0),
          ],
        ),
      ),
    );
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
