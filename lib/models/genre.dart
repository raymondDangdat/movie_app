class Genre{
  final int id;
  final String name;
  String error;
  Genre({this.name, this.id});

  Genre.withError(this.error, this.name, this.id);

  factory Genre.fromJson(dynamic json){
    if(json == null){
      return Genre();
    }
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}