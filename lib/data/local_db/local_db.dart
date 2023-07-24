import 'dart:convert';
import 'dart:io';
import 'package:code_management_test/data/model/movie/store_moive_object.dart';
import 'package:code_management_test/data/model/movie_detail/favourite_movie.dart';
import 'package:code_management_test/ui/movies/movies.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/movie/movie.dart';

class SqfliteHelper {
  final String movieTable = "movies";
  final String favouriteTable = "tblFavourites";
  Database? _dataBase;

  SqfliteHelper._privateConstructor();
  static final SqfliteHelper instance = SqfliteHelper._privateConstructor();
  Future<Database?> get database async {
    if (_dataBase != null) return _dataBase;
    _dataBase = await initializeDatabase();
    return _dataBase;
  }

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
    return openDatabase(path, readOnly: false);
  }

  Future<int?> storeMovies(StoreMovieObject movieInfo) async {
    final db = await instance.database;
    int done = await db!.insert(movieTable, movieInfo.toJson());
    return done;
  }

  Future<List<StoreMovieObject>> getMoviesByType(MovieType movieType) async {
    final db = await instance.database;
    List<StoreMovieObject> movieList = [];
    try {
      List<Map<String, dynamic>> movies = await db!
          .query(movieTable, where: "type = ?", whereArgs: [movieType.name]);
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

  Future<void> saveFavouriteMovie(FavouriteMovie favouriteMovie) async {
    final db = await instance.database;

    await db!.insert(
      favouriteTable,
      favouriteMovie.toJson(),
    );
  }

  Future<void> unsaveFavouriteMovie(int movieId) async {
    final db = await instance.database;

    await db!
        .delete(favouriteTable, where: "movie_id = ? ", whereArgs: [movieId]);
  }

  Future<bool> checkMovieFavourite(int movieId) async {
    final db = await instance.database;

    final data = await db!
        .query(favouriteTable, where: "movie_id = ? ", whereArgs: [movieId]);
    if (data.length == 1) {
      return true;
    } else if (data.isEmpty) {
      return false;
    }
    return false;
  }

  Future truncateTable() async {
    final db = await instance.database;

    await db!.delete(movieTable);
  }
}
