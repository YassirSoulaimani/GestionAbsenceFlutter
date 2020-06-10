import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';

class Actualiter {
  final String id;
  final String name, imageUrl, description;

  Actualiter({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
  });

  factory Actualiter.fromJson(Map<String, dynamic> jsonData) {
    return Actualiter(
      id: jsonData['id'],
      name: jsonData['name'],
      description: jsonData['description'],
      imageUrl:
          "http://yassirtestflutter.000webhostapp.com/flutter_login/actualite/images/" +
              jsonData['image_url'],
    );
  }
}

class CustomListView extends StatelessWidget {
  final List<Actualiter> spacecrafts;

  CustomListView(this.spacecrafts);

  Widget build(context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: spacecrafts.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(spacecrafts[currentIndex], context);
      },
    );
  }

  Widget createViewItem(Actualiter spacecraft, BuildContext context) {
    return new ListTile(
        title: new Card(
          elevation: 5.0,
          child: new Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                new Container(
                  height: 200,
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                    fit: BoxFit.fill,
                    alignment: FractionalOffset.topCenter,
                    image: new NetworkImage(spacecraft.imageUrl),
                  )),
                ),
                /* SizedBox(
                  width: 450, // custom width
                  height: 200, //
                  child: Image.network(spacecraft.imageUrl),
                  //padding: EdgeInsets.only(bottom: 8.0),
                ),*/
                Row(children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0),

                      child: Text(
                        spacecraft.name,
                        style: new TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        //overflow: TextOverflow.visible,
                      ),
                      //padding: EdgeInsets.all(10.0)),
                      //Text(" | "),
                      /*Padding(
                      child: Text(
                        spacecraft.propellant,
                        style: new TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.all(1.0)),*/
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
        onTap: () {
          //We start by creating a Page Route.
          //A MaterialPageRoute is a modal route that replaces the entire
          //screen with a platform-adaptive transition.
          var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
                new SecondScreen(value: spacecraft),
          );
          //A Navigator is a widget that manages a set of child widgets with
          //stack discipline.It allows us navigate pages.
          Navigator.of(context).push(route);
        });
  }
}

//Future is n object representing a delayed computation.
Future<List<Actualiter>> downloadJSON() async {
  final jsonEndpoint =
      "http://yassirtestflutter.000webhostapp.com/flutter_login/actualite/";

  final response = await get(jsonEndpoint);

  if (response.statusCode == 200) {
    List spacecrafts = json.decode(response.body);
    return spacecrafts
        .map((spacecraft) => new Actualiter.fromJson(spacecraft))
        .toList();
  } else
    throw Exception('We were not able to successfully download the json data.');
}

class SecondScreen extends StatefulWidget {
  final Actualiter value;

  SecondScreen({Key key, this.value}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.brown, //change your color here
        ),
        title: new Text(
          'Detail Page',
          style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  color: Colors.brown,
                  fontSize: 15,
                  fontWeight: FontWeight.w900)),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.brown,
      body: new Container(
        child: new Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Padding(
                child: new Text(
                  '${widget.value.name}',
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.all(10.0),
              ),
              Padding(
                child: Container(
                  height: 250,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      image: new DecorationImage(
                        fit: BoxFit.contain,
                        alignment: FractionalOffset.topCenter,
                        image: new NetworkImage('${widget.value.imageUrl}'),
                      )),
                  //child: Image.network('${widget.value.imageUrl}')
                ),
                padding: EdgeInsets.all(12.0),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                child: new Text(
                  '${widget.value.description}',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.all(20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: ListView(children: <Widget>[
        Container(
          height: 50,
          color: Color(0xffF1F1F3),
          child: Center(
            child: Text(
              'Actualités',
              style: TextStyle(color: Colors.brown, fontSize: 20),
            ),
          ),
        ),
        FutureBuilder<List<Actualiter>>(
          future: downloadJSON(),
          //we pass a BuildContext and an AsyncSnapshot object which is an
          //Immutable representation of the most recent interaction with
          //an asynchronous computation.
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Actualiter> spacecrafts = snapshot.data;
              return new CustomListView(spacecrafts);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            //return  a circular progress indicator.
            return new CircularProgressIndicator();
          },
        ),
      ]),
    );
  }
}
