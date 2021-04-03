import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_api/bloc/genre_bloc/genre_bloc.dart';
import 'package:movies_api/bloc/genre_bloc/genre_event.dart';
import 'package:movies_api/bloc/genre_bloc/genre_state.dart';
import 'package:movies_api/models/genre.dart';
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
          BlocProvider<GenreBloc>(create: (_) => GenreBloc()..add(GenreEventStarted()))
        ], child: _buildGenre(context));
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
                              Container(
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
            })
      ],
    );
  }
}
