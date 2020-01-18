class Person {
  final String name;
  final String birthDate;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String gender;
  final String height;
  int id;
  final List<dynamic> films;


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

  Person({ this.name, this.birthDate, this.mass, this.hairColor, this.skinColor, this.eyeColor, this.gender, this.height, this.films, this.id});

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
      films: json['films'] as List<dynamic>,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mass': mass,
      'hair_color': hairColor,
      'skin_color': skinColor,
      'eye_color': eyeColor,
      'birth_year': birthDate,
      'height': height,
      'gender': gender
//      'films': skinColor,
    };
  }
}