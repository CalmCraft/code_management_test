import 'dart:io';

import 'package:code_management_test/data/model/store_moives_object.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    dataBase = await openDatabase(path, readOnly: true);

    return dataBase;
  }

  Future<int?> storeMovies(StoreMovieObject movieInfo) async {
    final db = dataBase;
    int done = await db!.insert(movieTable, movieInfo.toJson());
    return done;
  }
}
