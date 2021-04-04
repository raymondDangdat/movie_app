import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_api/bloc/genre_bloc/genre_bloc.dart';
import 'package:movies_api/bloc/genre_bloc/genre_event.dart';
import 'package:movies_api/bloc/genre_bloc/genre_state.dart';
import 'package:movies_api/bloc/movie_bloc/movie_bloc.dart';
import 'package:movies_api/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:movies_api/bloc/movie_bloc/movie_bloc_state.dart';
import 'package:movies_api/models/genre.dart';
import 'package:movies_api/models/models.dart';
import 'package:movies_api/screens/movie_details_screen.dart';
class BuildWidgetCategory extends StatefulWidget {
  final int selectedGenre;
  const BuildWidgetCategory({Key key, this.selectedGenre = 28});
  @override
  _BuildWidgetCategoryState createState() => _BuildWidgetCategoryState();
}

class _BuildWidgetCategoryState extends State<BuildWidgetCategory> {
  int selectedGenre;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedGenre = widget.selectedGenre;
    });
  }
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
          BlocProvider<GenreBloc>(create: (_) => GenreBloc()..add(GenreEventStarted())
          ),
          BlocProvider<MovieBloc>(create: (_) => MovieBloc()..add(MovieEventStarted(selectedGenre, '')))
        ], child: _buildGenre(context)
    );
  }

  Widget _buildGenre(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<GenreBloc, GenreState>(
            builder: (context, state){
              if(state is GenreLoading){
                return Center(
                  child: Platform.isAndroid? CircularProgressIndicator()
                      : CupertinoActivityIndicator(),
                );
              }else if(state is GenreLoaded){
                List<Genre> genres = state.genreList;
                return Container(
                  height: 45,
                    child: ListView.separated(
                        itemBuilder: (context, index){
                          Genre genre = genres[index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap:(){
                                  setState(() {
                                    Genre genre = genres[index];
                                    selectedGenre = genre.id;
                                    context.read<MovieBloc>().add(MovieEventStarted(selectedGenre, ''));
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black45),
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                    color: (genre.id == selectedGenre) ?
                                        Colors.black45
                                        : Colors.white,
                                  ),
                                  child: Text(genre.name.toUpperCase(),style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: (genre.id == selectedGenre)
                                      ? Colors.white
                                        : Colors.black,
                                    fontFamily: 'Gurmukhi MN'
                                  ),),
                                ),
                              )
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => VerticalDivider(
                          color: Colors.transparent,
                          width: 5.0,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: genres.length),
                );
              }else{
                return Container();
              }
            }),

        SizedBox(
          height: 10.0,
        ),
        Container(child: Text("New Playing".toUpperCase(),style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white54, ),)
        ),

        SizedBox(height: 10.0,),
        BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state){
            if(state is MovieLoading){
              return Center();
            }else if(state is MovieLoaded){
              List<Movies> movieList = state.movieList;

              return Container(
                height: 340,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index){
                      Movies movie = movieList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie,)));
                            },
                            child: ClipRRect(
                              child: CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                                imageBuilder: (context, imageProvider){
                                  return Container(
                                    width: 190,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                      image: DecorationImage(
                                          image: imageProvider,
                                      fit: BoxFit.cover)
                                    ),
                                  );
                                },
                                placeholder: (context, url) => Container(
                                  width: 190.0,
                                  height: 250.0,
                                  child: Center(
                                    child: Platform.isAndroid
                                    ? CircularProgressIndicator()
                                    : CupertinoActivityIndicator(),

                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 190,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/noimage.png')
                                    )                                ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            width: 180,
                            child: Text(movie.title.toUpperCase(), style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              fontFamily: 'Gurmukhi MN'
                            ), overflow: TextOverflow.ellipsis,),
                          ),

                          Container(
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellowAccent, size: 14,),
                                Icon(Icons.star, color: Colors.yellowAccent, size: 14,),
                                Icon(Icons.star, color: Colors.yellowAccent, size: 14,),
                                Icon(Icons.star, color: Colors.yellowAccent, size: 14,),
                                Icon(Icons.star, color: Colors.yellowAccent, size: 14,),
                                Text(movie.voteAverage.toString())
                              ],
                            ),
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => VerticalDivider(
                      color: Colors.transparent,
                      width: 15.0,
                    ) ,
                    scrollDirection: Axis.horizontal,
                    itemCount: movieList.length),
              );
            }else{
              return Container();
            }
          },
            )
      ],
    );
  }
}
