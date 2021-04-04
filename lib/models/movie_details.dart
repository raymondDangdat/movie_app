import 'package:movies_api/models/models.dart';

class MovieDetail{
  final String id;
  final String title;
  final String backdropPath;
  final String budget;
  final String homePage;
  final String originalTitle;
  final String overview;
  final String voteAverage;
  final String voteCount;
  final String releaseDate;
  final String runtime;

  String trailerId;
  MovieImage movieImage;
  List<Cast> castList;


  MovieDetail(
  {
  this.id,
  this.title,
  this.backdropPath,
  this.budget,
  this.homePage,
  this.originalTitle,
  this.overview,
  this.voteAverage,
  this.voteCount,
    this.releaseDate,
    this.runtime,
  this.trailerId,
});

  factory MovieDetail.fromJson(dynamic json){
    if(json == null){
      return MovieDetail();
    }
    return MovieDetail(
      id: json['id'].toString(),
      title: json['title'],
      backdropPath: json['backdrop_path'],
      budget: json['budget'].toString(),
      homePage: json['home_page'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      voteAverage: json['vote_average'].toString(),
      voteCount: json['vote_count'].toString(),
      releaseDate: json['release_date'],
      runtime: json['runtime'].toString(),
    );
    }
}