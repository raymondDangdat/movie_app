import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_api/api_calls/api_service.dart';
import 'package:movies_api/bloc/genre_bloc/genre_state.dart';
import 'package:movies_api/models/models.dart';

import 'genre_event.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState>{
  GenreBloc() : super(GenreLoading());

  @override
  Stream<GenreState> mapEventToState(GenreEvent event) async*{
    if(event is GenreEventStarted){
      yield* _mapMovieEventStateToState();
    }
  }

  Stream<GenreState> _mapMovieEventStateToState() async*{
    final service = APiService();
    yield GenreLoading();
    try{
      List<Genre> genreList = await service.getGenreList();
      yield GenreLoaded(genreList);
    }on Exception catch (err){
      print(err);
      yield GenreError();
    }
  }

}