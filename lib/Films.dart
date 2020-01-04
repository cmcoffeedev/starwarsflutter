class Films {
  final String title;
  final String releaseDate;



  Films({ this.title, this.releaseDate, });

  factory Films.fromJson(Map<String, dynamic> json) {
    return Films(
      title: json['title'] as String,
      releaseDate: json['release_date'] as String,

    );
  }
}