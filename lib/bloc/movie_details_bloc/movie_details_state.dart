import 'package:equatable/equatable.dart';
import 'package:movies_api/models/models.dart';

abstract class MovieDetailState extends Equatable{
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailLoading extends MovieDetailState{}

class MovieDetailError extends MovieDetailState{}

class MovieDetailsLoaded extends MovieDetailState{
  final MovieDetail movieDetail;
  const MovieDetailsLoaded(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}


