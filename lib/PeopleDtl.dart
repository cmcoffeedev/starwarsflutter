import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Person.dart';
import 'package:starswarsflutter/Films.dart';
import 'package:url_launcher/url_launcher.dart';


class PeopleDtl extends StatefulWidget {

  PeopleDtl({Key key, this.person, this.id}) : super(key: key);

  final Person person;
  final int id;

  @override
  _PeopleDtlState createState() => _PeopleDtlState();
}



Future<List<Films>> fetchFilms(http.Client client, PeopleDtl widget) async {
  final response =
  await client.get('https://swapi.co/api/films/?format=json');

  // Use the compute function to run parsePhotos in a separate isolate.

  Map<String, dynamic> args = Map();
  args["body"] = response.body;
  args["widget"] = widget;

//  return compute(parseFilms, response.body);
  return compute(parseFilms, args);
}

// A function that converts a response body into a List<Photo>.
List<Films> parseFilms(Map args) {
  String responseBody = args["body"];
  PeopleDtl widget = args["widget"];

  final parsed = jsonDecode(responseBody);
  var results = parsed['results'];

  List<dynamic> films = widget.person.films;
  List<dynamic> cleanResults = List<dynamic>();
  for( var x in results){
    var url = x['url'];
    if(films.contains(url)){
       cleanResults.add(x);
    }

  }


  return cleanResults.map<Films>((json) => Films.fromJson(json)).toList();
}



class _PeopleDtlState extends State<PeopleDtl> {




  var database;




  _launchURL(PeopleDtl widget) async {
//    const url = 'mailto:smith@example.org?subject=News&body=New%20plugin';
    var name = widget.person.name;
    var birth_year = widget.person.birthDate;
    var body = 'Their name is $name\n.Birth year is $birth_year.';
    var subject = '$name info.';
    var encodedBody = Uri.encodeFull(body);
    var encodedSubject = Uri.encodeFull(subject);

    var url = 'mailto:?subject=$encodedSubject&body=$encodedBody';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initDb();

  }

  /*
"name": "Luke Skywalker",
		"height": "172",
		"mass": "77",
		"hair_color": "blond",
		"skin_color": "fair",
		"eye_color": "blue",
		"birth_year": "19BBY",
		"gender": "male",
 */

  Future initDb() async {

    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'person_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE person(id INTEGER PRIMARY KEY,  name TEXT, height TEXT, mass TEXT, hair_color TEXT, skin_color TEXT, eye_color TEXT, birth_year TEXT, gender TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );


  }


  Future<void> insertDog(Person person) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'person',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  @override
  Widget build(BuildContext context) {
//    return Container(color: Colors.blue,);
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.person.name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              RaisedButton(
                color: Colors.black,
                child: Text("Add To Favorites", style: TextStyle(color: Colors.yellow),),
                onPressed: (){

                  insertDog(widget.person);


                },
              ),
              RaisedButton(
               child: Text("Share ${widget.person.name}'s info"),
                onPressed: (){


                  _launchURL(widget);

                },
              ),
              Text(
                "Name: ${widget.person.name}",
              ),
              Text(
                "Birth Year: ${widget.person.birthDate}",
              ),
              Text(
                "Height: ${widget.person.height}",
              ),
              Text(
                "Mass: ${widget.person.mass}",
              ),
              Text(
                "Hair Color: ${widget.person.hairColor}",
              ),
              Text(
                "Skin Color: ${widget.person.skinColor}",
              ),
              Text(
                "Eye Color: ${widget.person.eyeColor}",
              ),
              Text(
                "Gender: ${widget.person.gender}",
              ),
              FutureBuilder<List<Films>>(
                future: fetchFilms(http.Client(), widget),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);

                  return snapshot.hasData
                      ? FilmsList(films: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                },
              ),

            ],
          ),
        ),
      );
  }
}

class FilmsList extends StatelessWidget {
  final List<Films> films;

  FilmsList({Key key, this.films}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0,
      child: ListView.builder(
        itemCount: films.length,
        itemBuilder: (context, index) {
          var title = films[index].title;
          var release = films[index].releaseDate;
          return ListTile(
            title: Text(title),
            subtitle: Text(release),

          );
        },
      ),
    );
  }
}
