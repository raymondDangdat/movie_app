import 'package:dio/dio.dart';
import 'package:movies_api/api_key.dart';
import 'package:movies_api/models/models.dart';

class APiService{
  final _dio = Dio();

  final String basedUrl = "https://api.themoviedb.org/3";
  final String apiKey = 'api_key=$key';

  Future<List<Movies>> getNowPlayingMovies() async{
    try{
      print("API Call");
      final url = '$basedUrl/movie/now_playing?$apiKey';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      List<Movies> movieList = movies.map((movie) => Movies.fromJson(movie)).toList();
      return movieList;
    }catch(err, stacktrace){
      throw Exception('Exception occurred: $err with stacktrace: $stacktrace');
    }
  }

  Future<List<Movies>> getMoviesByGenre(int movieId) async{
    try{
      print("API Call");
      final url = '$basedUrl/discover/movie?/with_genres=$movieId&$apiKey';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      List<Movies> movieList = movies.map((movie) => Movies.fromJson(movie)).toList();
      return movieList;
    }catch(err, stacktrace){
      throw Exception('Exception occurred: $err with stacktrace: $stacktrace');
    }
  }

  Future<List<Genre>> getGenreList() async{
    try{
      final response = await _dio.get('$basedUrl/genre/movie/list?$apiKey');
      var genres = response.data['genres'] as List;
      List<Genre> genreList = genres.map((gen) => Genre.fromJson(gen)).toList();
      return genreList;
    }catch(err, stacktrace){
      print(err);
      throw Exception('Exception occurred: $err with stacktrace: $stacktrace');
    }
  }

  Future<List<Person>> getTrendingPerson() async{
    try{
      final response = await _dio.get('$basedUrl/trending/person/week?$apiKey');
      var persons = response.data['results'] as List;
      List<Person> personList = persons.map((person) => Person.fromJson(person)).toList();
      return personList;
    }catch(err, stacktrace){
      print(err);
      throw Exception('Exception occurred: $err with stacktrace: $stacktrace');
    }
  }
}