import 'package:dio/dio.dart';
import 'package:movies_api/api_key.dart';
import 'package:movies_api/models/models.dart';

class APiService{
  final _dio = Dio();

  final String basedUrl = "https://api.themoviedb.org/3";
  final String apiKey = 'api_key=$KEY';

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

  Future<MovieDetail> getMovieDetail(int movieId) async{
    try{
      final response = await _dio.get('$basedUrl/movie/$movieId?&$apiKey');
      MovieDetail movieDetail = MovieDetail.fromJson(response.data);
      movieDetail.trailerId = await getYoutubeId(movieId);
      movieDetail.movieImage = await getMovieImage(movieId);
      movieDetail.castList = await getCastList(movieId);
      return movieDetail;
    }catch(error, stacktrace){
      print(error);
      throw Exception('Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<String> getYoutubeId(int id) async{
    try{
      final response = await _dio.get('$basedUrl/movie/$id/videos?$apiKey');
      var youtubeId = response.data['results'][0]['key'];
      return youtubeId;
    }catch(error, stacktrace){
      print(error);
      throw Exception('Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<MovieImage> getMovieImage(int movieId) async{
    try{
      final response = await _dio.get('$basedUrl/movie/$movieId/images?$apiKey');
      return MovieImage.fromJson(response.data);
    }catch(error, stacktrace){
      print(error);
      throw Exception('Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Cast>> getCastList(int movieId) async{
    try{
      final response = await _dio.get('$basedUrl/movie/$movieId/credits?$apiKey');
      var list = response.data['cast'] as List;
      List<Cast> castList = list.map((data) => Cast(
        name: data['name'],
        profilePath: data['profile_path'],
        character: data['character'],
      )).toList();
      return castList;
    }catch(error, stacktrace){
      print(error);
      throw Exception('Exception occurred: $error with stacktrace: $stacktrace');
    }
  }
}