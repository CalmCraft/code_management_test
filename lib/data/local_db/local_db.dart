import 'dart:convert';
import 'dart:io';
import 'package:code_management_test/data/model/movie/store_moive_object.dart';
import 'package:code_management_test/ui/movies/movies.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/movie/movie.dart';

class LocalDB {
  Database? dataBase;
  final String movieTable = "movies";
  Future<Database?> initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "movies_db.db");

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets/db", "movies_db.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {}
    dataBase = await openDatabase(path, readOnly: false);
    return dataBase;
  }

  Future<int?> storeMovies(StoreMovieObject movieInfo) async {
    final db = dataBase;
    int done = await db!.insert(movieTable, movieInfo.toJson());
    return done;
  }

  Future<List<StoreMovieObject>> getUpcomingMovies() async {
    final db = dataBase;
    List<StoreMovieObject> movieList = [];
    try {
      List<Map<String, dynamic>> movies = await db!.query(movieTable,
          where: "type = ?", whereArgs: [MovieType.upcoming.name]);
      movieList =
          movies.map((data) => StoreMovieObject.fromJson(data)).toList();
      for (var movie in movieList) {
        final decodedString = jsonDecode(movie.movieInfo.toString());
        movie.movie = Movie.fromJson(decodedString);
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
    return movieList;
  }

  Future<List<StoreMovieObject>> getPopularMovies() async {
    final db = dataBase;
    List<StoreMovieObject> movieList = [];
    try {
      List<Map<String, dynamic>> movies = await db!.query(movieTable,
          where: "type = ?", whereArgs: [MovieType.popular.name]);
      movieList =
          movies.map((data) => StoreMovieObject.fromJson(data)).toList();
      for (var movie in movieList) {
        final decodedString = jsonDecode(movie.movieInfo.toString());
        movie.movie = Movie.fromJson(decodedString);
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
    return movieList;
  }

  Future truncateTable() async {
    final db = dataBase;

    await db!.delete(movieTable);
  }
}
