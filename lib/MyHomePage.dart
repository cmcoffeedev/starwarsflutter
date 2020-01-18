import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:starswarsflutter/Favorites.dart';
import 'Person.dart';
import 'PeopleDtl.dart';

Future<List<Person>> fetchPeople(http.Client client) async {
  final response = await client.get('https://swapi.co/api/people/?format=json');

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
  TextEditingController searchController = TextEditingController();
  List<Person> initialData = List<Person>();
  List<Person> shownList = List<Person>();

  void queryPeople(String queryString) {
    List<Person> copyList = List<Person>();

    print("queryString = $queryString");

    setState(() {
//      if (queryString.isNotEmpty) {
//        for (var x in initialData) {
//          var name = x.name;
//          if (name.toLowerCase().contains(queryString.toLowerCase())) {
//            copyList.add(x);
//          }
//        }
//
//        shownList = copyList;
//      } else {
//        shownList = initialData;
//      }

    shownList = initialData.where((string){

      if(string.name.toLowerCase().contains(queryString.toLowerCase())){
       return true;
      }
      else return false;

    }).toList();

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchPeople(http.Client()).then((value) {
      setState(() {
        initialData = value;
        shownList = value;
      });
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
      body: Column(
        children: <Widget>[
          TextField(controller: searchController, onChanged: queryPeople),
          RaisedButton(
            child: Text("Share"),
            onPressed: () {
              Share.share("Check out my cool Star Wars app!");
            },
          ),
          RaisedButton(
            child: Text("Favorites"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Favorites()),
              );
            },
          ),
          Expanded(
//            child: FutureBuilder<List<Person>>(
//              future: fetchPeople(http.Client()),
//              builder: (context, snapshot) {
//                if (snapshot.hasError) print(snapshot.error);
//
//                return snapshot.hasData
//                    ? PeopleList(people: snapshot.data)
//                    : Center(child: CircularProgressIndicator());
//              },
//            ),
            child: PeopleList(
              people: shownList,
            ),
          ),
        ],
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
          onTap: () {
            person.id = index;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PeopleDtl(person: person, id: index)),
            );
          },
        );
      },
    );
  }
}
