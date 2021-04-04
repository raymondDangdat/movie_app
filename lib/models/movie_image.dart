import 'package:equatable/equatable.dart';
import 'package:movies_api/models/models.dart';

class MovieImage extends Equatable{
  final List<Screenshot> backdrops;
  final List<Screenshot> posters;

  MovieImage({this.backdrops, this.posters});

  factory MovieImage.fromJson(Map<String, dynamic> result){
    if(result == null){
      return MovieImage();
    }
    return MovieImage(
      backdrops: (result['backdrops'] as List) ?.map((e) => Screenshot.fromJson(e))?.toList()??
        List.empty(),
      posters: (result['posters'] as List)
        ?.map((e) => Screenshot.fromJson(e))
        ?.toList() ??
        List.empty(),
    );
  }

  @override
  List<Object> get props => [backdrops, posters];
}
