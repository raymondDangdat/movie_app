

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_api/bloc/movie_bloc/movie_bloc.dart';
import 'package:movies_api/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:movies_api/bloc/movie_bloc/movie_bloc_state.dart';
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
