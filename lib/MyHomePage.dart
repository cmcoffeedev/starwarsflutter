import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Person.dart';
import 'PeopleDtl.dart';

Future<List<Person>> fetchPeople(http.Client client) async {
  final response =
  await client.get('https://swapi.co/api/people/?format=json');

//  var data = await json.decode(response.body);

//  return data;

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePeople, response.body);
}


List<Person> parsePeople(String responseBody) {
  final parsed = jsonDecode(responseBody);
  var results = parsed['results'];

  return results.map<Person>((json) => Person.fromJson(json)).toList();
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Person>>(
        future: fetchPeople(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PeopleList(people: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


class PeopleList extends StatelessWidget {
  final List<Person> people;
//  final dynamic people;

  PeopleList({Key key, this.people}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return ListView.builder(
      itemCount: people.length,
      itemBuilder: (context, index) {
        var person = people[index];
        var name = person.name;
        var birthYear = person.birthDate;
      return ListTile(
        title: Text(name),
        subtitle: Text(birthYear),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PeopleDtl(person:person)),
          );
        },
      );
      },
    );
  }
}
