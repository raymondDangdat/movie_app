import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_api/api_calls/api_service.dart';
import 'package:movies_api/bloc/person_bloc/person_event.dart';
import 'package:movies_api/bloc/person_bloc/person_state.dart';
import 'package:movies_api/models/models.dart';



class PersonBloc extends Bloc<PersonEvent, PersonState>{
  PersonBloc() : super(PersonLoading());

  @override
  Stream<PersonState> mapEventToState(PersonEvent event) async*{
    if(event is PersonEventStarted){
      yield* _mapMovieEventStateToState();
    }
  }

  Stream<PersonState> _mapMovieEventStateToState() async*{
    final service = APiService();
    yield PersonLoading();
    try{
      List<Person> personList = await service.getTrendingPerson();
      yield PersonLoaded(personList);
    }on Exception catch (err){
      print(err);
      yield PersonError();
    }
  }

}