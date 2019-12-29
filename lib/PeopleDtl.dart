import 'package:flutter/material.dart';
import 'Person.dart';


class PeopleDtl extends StatefulWidget {

  PeopleDtl({Key key, this.person}) : super(key: key);

  final Person person;

  @override
  _PeopleDtlState createState() => _PeopleDtlState();
}

class _PeopleDtlState extends State<PeopleDtl> {

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
            ],
          ),
        ),
      );
  }
}
