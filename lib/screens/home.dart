

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_api/bloc/movie_bloc/movie_bloc.dart';
import 'package:movies_api/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:movies_api/bloc/movie_bloc/movie_bloc_state.dart';
import 'package:movies_api/bloc/person_bloc/person.dart';
import 'package:movies_api/models/models.dart';
import 'package:movies_api/widgets/widgets.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MovieBloc>(create: (_) => MovieBloc()..add(MovieEventStarted(0, '')), ),
          BlocProvider<PersonBloc>(create: (_) => PersonBloc()..add(PersonEventStarted()),)
        ],   child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: (){}),
        title: Text("SmartMovies", style: TextStyle(fontSize: 22.0, letterSpacing: -1),),
        centerTitle: true,
      ),

      body: _buildBody(context),
    ),
    );
  }

  Widget _buildBody(BuildContext context){
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){
        return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<MovieBloc, MovieState>(
                    builder: (context, state){
                      if(state is MovieLoading){
                        return Center(
                          child: Platform.isAndroid ? CircularProgressIndicator()
                          : CupertinoActivityIndicator(),
                        );
                      }else if(state is MovieLoaded){
                        List<Movies> movies = state.movieList;
                        return Column(
                          children: [
                            CarouselSlider.builder(
                                itemCount: movies.length,
                                itemBuilder: (BuildContext context, int index){
                                  Movies movie = movies[index];
                                  return Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      ClipRRect(
                                        child: CachedNetworkImage(
                                          imageUrl: 'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                                          height: MediaQuery.of(context).size.height / 3,
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Platform.isAndroid? CircularProgressIndicator()
                                          : CupertinoActivityIndicator(),
                                          errorWidget: (context, url, error) => Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('assets/noimage.png'),
                                              )
                                            ),
                                          ),
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 15.0,
                                            left: 15
                                          ),
                                      child: Text(movie.title.toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0, fontFamily: 'Gurmukhi MN'), overflow: TextOverflow.ellipsis,),)
                                    ],
                                  );
                                }, options: CarouselOptions(
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 5),
                              autoPlayAnimationDuration: Duration(microseconds: 800),
                              pauseAutoPlayOnTouch: true,
                              viewportFraction: 0.8,
                              enlargeCenterPage: true,
                            )),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 12.0,),
                                BuildWidgetCategory(),
                                Text('Trending person on this week'.toUpperCase(), style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, fontFamily: 'Gurmukhi MN'),),
                                SizedBox(height: 12.0,),
                                Column(
                                  children: [
                                    BlocBuilder<PersonBloc, PersonState>(
                                        builder: (context, state){
                                          if(state is PersonLoading){
                                            return Center();
                                          }else if(state is PersonLoaded){
                                            List<Person> personList = state.personList;
                                            // print(personList);
                                            return Container(
                                              height: 110,
                                              child: ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                  itemBuilder: (context, index){
                                                  Person person = personList[index];
                                                  return Container(
                                                    child: Column(
                                                      children: [
                                                        Card(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(100.0),
                                                          ),
                                                          elevation: 3.0,
                                                          child: ClipRRect(
                                                            child: CachedNetworkImage(
                                                              imageUrl: 'https://image.tmdb.org/t/p/w200${person.profilePath}',
                                                              imageBuilder: (context, imageProvider){
                                                                return Container(
                                                                  width: 80.0,
                                                                  height: 80.0,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                                                    image: DecorationImage(
                                                                        image: imageProvider, fit: BoxFit.cover)
                                                                  ),
                                                                );
                                                              },
                                                              placeholder: (context, url) => Container(
                                                                width: 80.0,
                                                                height: 80.0,
                                                                child: Center(
                                                                  child: Platform.isAndroid
                                                                  ? CircularProgressIndicator()
                                                                  : CupertinoActivityIndicator(),

                                                                ),
                                                              ),
                                                              errorWidget: (context, url, error) => Container(
                                                                width: 80.0,
                                                                height: 80.0,
                                                                decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                    image: AssetImage('assets/noimage.png'),
                                                                  )
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Center(),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                  },
                                                  separatorBuilder: (context, index) =>
                                                  VerticalDivider(
                                                    color: Colors.transparent,
                                                    width: 5.0,
                                                  ),
                                                  itemCount: personList.length),
                                            );
                                          }else{
                                            return Container(child: Text("Something went wrong"),);
                                          }
                                        })
                                  ],
                                )
                              ],
                            ),)
                          ],
                        );
                      }else{
                        return Container(
                          child: Text("Something went wrong!!!"),
                        );
                      }
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
