import 'package:code_management_test/data/model/movie.dart';

class MovieList {
  List<Movie>? results;

  MovieList({this.results});

  MovieList.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Movie>[];
      json['results'].forEach((v) {
        results!.add(Movie.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
