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
      print(err);
      throw Exception('Exception occurred: $err with stacktrace: $stacktrace');
    }
  }
}