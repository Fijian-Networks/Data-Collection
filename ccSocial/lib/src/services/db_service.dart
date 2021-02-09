import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:ccSocial/src/models/person.dart';

class DatabaseService {
  DatabaseService();

  String _dbPath = "/storage/emulated/0/opendatakit/default/data/webDb/";
  Database _db;
  String dbName = "sqlite.db";

  initDatabase() async {
    _db = await openDatabase(_dbPath + dbName);
    var path = join(_dbPath, dbName);
    print("dbPath in db_service :: " + path);
    // TODO: catch errors if no db exists on storage
    bool exists = await databaseExists(path);
    print("database exists?  " + exists.toString());
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    var data = File(path).readAsBytesSync();
    //write and flush bytes
    await File(path).writeAsBytes(data, flush: true);
    //Open the DB
    _db = await openDatabase(path, readOnly: true);
  }

// Default returns all instances of person from DB,
// call with getPersons(query : 'QUERY GOES HERE')
// TODO: Filter logic goes here?
  Future<List<Person>> getPersons({String query = ''}) async {
    String queryCat;
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
