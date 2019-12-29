class Person {
  final String name;
  final String birthDate;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String gender;
  final String height;


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

  Person({ this.name, this.birthDate, this.mass, this.hairColor, this.skinColor, this.eyeColor, this.gender, this.height});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      birthDate: json['birth_year'] as String,
      mass: json['mass'] as String,
      hairColor: json['hair_color'] as String,
      skinColor: json['skin_color'] as String,
      eyeColor: json['eye_color'] as String,
      gender: json['gender'] as String,
      height: json['height'] as String,
    );
  }
}