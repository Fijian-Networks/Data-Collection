import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import 'package:ccSocial/src/models/person.dart';

class DatabaseService {
  DatabaseService();

  String _dbPath = "/storage/emulated/0/opendatakit/default/data/webDB/";
  Database _db;
  //NAME OF DATABASE FILE IN ASSETS :: Temporary for developement. final production will be sqlite.db in android ODK-X folder
  String dbName = "sqlite.db";

  initDatabase() async {
//    _db = await openDatabase('assets/' + db_name);
    _db = await openDatabase(_dbPath + dbName);

    var databasePath = await getDatabasesPath();
    var path = join(databasePath, dbName);
    print("dbPath in db_service :: " + path);

    //check if DB exists
    var exists = await databaseExists(path);

    if (!exists) {
      print('Creating a new DB copy from assets');

      //check if parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      //copy from assets
      ByteData data = await rootBundle.load(join(_dbPath, dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      //write and flush bytes
      await File(path).writeAsBytes(bytes, flush: true);
    }

    //Open the DB
    _db = await openDatabase(path, readOnly: true);
  }

//Default returns all instances of person from DB,
// call with getPersons(query : 'QUERY GOES HERE')
  Future<List<Person>> getPersons({String query = ''}) async {
    String queryCat;
    await initDatabase();
    // rawQuery here defines what is selected from DB
    if (query.isEmpty) {
      queryCat =
          'SELECT * FROM household_member ORDER BY last_name, first_name';
    } else {
      queryCat = 'SELECT * FROM household_member WHERE (first_name LIKE \"%' +
          query +
          '%\" OR last_name LIKE \"%' +
          query +
          '%\") ORDER BY last_name, first_name';
    }
//SELECT * FROM household_member WHERE (first_name Like 'SEARCHVAR' OR last_name Like 'SEARCHVAR') ORDER BY first_name ASC, last_name ASC
    List<Map> list = await _db.rawQuery(queryCat);
    return list.map((person) => Person.fromJson(person)).toList();
  }

  dispose() {
    _db.close();
  }
}
