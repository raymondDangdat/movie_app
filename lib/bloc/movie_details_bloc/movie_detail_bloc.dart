import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_api/api_calls/api_service.dart';
import 'package:movies_api/bloc/movie_details_bloc/movie_details_event.dart';
import 'package:movies_api/bloc/movie_details_bloc/movie_details_state.dart';

class MovieDetailBLoc extends Bloc<MovieDetailEvent, MovieDetailState> {
  MovieDetailBLoc(): super(MovieDetailLoading());

  @override
  Stream<MovieDetailState> mapEventToState(MovieDetailEvent event) async*{
    if(event is MovieDetailEventStarted){
      yield* _mapMovieEventStartedToState(event.id);
    }
  }

  Stream<MovieDetailState> _mapMovieEventStartedToState(int id) async*{
    final apiRepository = APiService();
    yield MovieDetailLoading();
    try{
      final movieDetail = await apiRepository.getMovieDetail(id);
      yield MovieDetailsLoaded(movieDetail);
    }on Exception catch (error){
      print(error);
      yield MovieDetailError();
    }
  }

}