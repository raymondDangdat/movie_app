

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_api/bloc/movie_details_bloc/movie_detail.dart';
import 'package:movies_api/models/models.dart';
import 'package:url_launcher/url_launcher.dart';
class MovieDetailScreen extends StatefulWidget {
  final Movies movie;
  const MovieDetailScreen({Key key, this.movie}) : super(key: key);
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => MovieDetailBLoc()..add(MovieDetailEventStarted(widget.movie.id)),
    child: WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
      body: _buildDetailBody(context),
    ),),);
    
  }

  Widget _buildDetailBody(BuildContext context){
    return BlocBuilder<MovieDetailBLoc, MovieDetailState>(
        builder: (context, state){
          if(state is MovieDetailLoading){
            return Center(
              child: Platform.isAndroid ?
              CircularProgressIndicator() :
              CupertinoActivityIndicator(),
            );
          }else if (state is MovieDetailsLoaded){
            MovieDetail moviesDetail = state.movieDetail;
            return Stack(
              children: [
                ClipPath(
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/original/${moviesDetail.backdropPath}',
                      height: MediaQuery.of(context).size.height / 2,
                      width:  double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Platform.isAndroid ? CircularProgressIndicator() : CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/noimage.png')
                          )
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 120.0),
                      child: GestureDetector(
                        onTap: ()async{
                          final youtubeUrl = 'https://www.youtube.com/embed/${moviesDetail.trailerId}';
                          print(youtubeUrl);
                          if(await canLaunch(youtubeUrl)){
                            await launch(youtubeUrl);
                          }
                        },
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.play_circle_outline, color: Colors.yellow, size: 65,),
                              Text(moviesDetail.title.toUpperCase(), style: TextStyle(fontFamily: 'Gurmukhi MN', fontSize: 18.0, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 180.0,),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Overview".toUpperCase(), style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)
                            ],
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Container(
                          height: 35.0,
                          child: Text(moviesDetail.overview, maxLines: 2, overflow: TextOverflow.fade, style: TextStyle(fontFamily: 'Malayalam Sangam MN'),),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                          ],
                        )
                      ],
                    ),)


                  ],
                )
              ],
            );
          }else{
            return Container(
              child: Center(child: Text("Something went wrong!!!!!!!!!"),),
            );
          }
        });
  }
}
