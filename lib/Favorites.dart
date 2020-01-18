import 'package:flutter/material.dart';
import 'package:starswarsflutter/PeopleDtl.dart';
import 'Person.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  var database;

  List<Person> people = List<Person>();

  Future initDb() async {
    database = await openDatabase(
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

    getPeople().then((value) {
      setState(() {
        people = value;
      });
    });
  }

  Future<List<Person>> getPeople() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('person');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Person(
        id: maps[i]['id'],
        name: maps[i]['name'] as String,
        birthDate: maps[i]['birth_year'] as String,
        mass: maps[i]['mass'] as String,
        hairColor: maps[i]['hair_color'] as String,
        skinColor: maps[i]['skin_color'] as String,
        eyeColor: maps[i]['eye_color'] as String,
        gender: maps[i]['gender'] as String,
        height: maps[i]['height'] as String,
      );
    });
  }

//  Future<void> updateDog(Person dog) async {
//    // Get a reference to the database.
//    final db = await database;
//
//    // Update the given Dog.
//    await db.update(
//      'dogs',
//      dog.toMap(),
//      // Ensure that the Dog has a matching id.
//      where: "id = ?",
//      // Pass the Dog's id as a whereArg to prevent SQL injection.
//      whereArgs: [dog.id],
//    );
//  }

  Future<void> deletePerson(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'person',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: ListView.builder(
          itemCount: people.length,
          itemBuilder: (context, index) {
            var person = people[index];
            return ListTile(
              title: Text(person.name),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PeopleDtl(person: person, id: index)),
                );
              },
              trailing: RaisedButton(
                color: Colors.red,
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  deletePerson(person.id).then((value) {
                    getPeople().then((value) {
                      setState(() {
                        people = value;
                      });
                    });
                  });
                },
              ),
            );
          }),
    );
  }
}
