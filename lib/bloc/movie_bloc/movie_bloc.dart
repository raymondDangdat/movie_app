import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_api/api_calls/api_service.dart';
import 'package:movies_api/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:movies_api/bloc/movie_bloc/movie_bloc_state.dart';
import 'package:movies_api/models/models.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState>{
  MovieBloc() : super(MovieLoading());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async*{
    if(event is MovieEventStarted){
      yield* _mapMovieEventStateToState(event.movieId, event.query);
    }
  }

  Stream<MovieState> _mapMovieEventStateToState(int movieId, String query) async*{
    final service = APiService();
    yield MovieLoading();
    try{
      List<Movies> movieList;
      if(movieId == 0){
        movieList = await service.getNowPlayingMovies();
      }else{
        movieList = await service.getMoviesByGenre(movieId);
      }
      yield MovieLoaded(movieList);
    }on Exception catch (err){
      yield MovieError();
    }
  }

}