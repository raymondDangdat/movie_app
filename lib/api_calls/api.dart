import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies_api/api_key.dart';
import 'package:movies_api/models/movie.dart';
import 'package:http/http.dart' as http;

// "https://www.omdbapi.com/?s=Batman&page=2&apikey=564727fa"

Future<List<Movie>> fetchAllMovies() async {
  final response = await http.get(api_key);

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    print(result);
    Iterable list = result["Search"];
    return list.map((movie) => Movie.fromJson(movie)).toList();
  } else {
    throw Exception("Failed to load movies!");
  }
}
