import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import 'package:ccSocial/src/models/person.dart';

class DatabaseService {
  Database _db;

  initDatabase() async {
    _db = await openDatabase('assets/sqlite.db');
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, 'sqlite.db');

    //check if DB exists
    var exists = await databaseExists(path);

    if (!exists) {
      print('Creating a new DB copy from assets');

      //check if parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      //copy from assets
      ByteData data = await rootBundle.load(join('assets/db', 'sqlite.db'));
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
      queryCat = 'SELECT * FROM household_member';
    } else {
      queryCat = 'SELECT * FROM household_member WHERE (first_name LIKE \"%' +
          query +
          '%\" OR last_name LIKE \"%' +
          query +
          '%\") ORDER BY first_name ASC, last_name ASC';
    }
//SELECT * FROM household_member WHERE (first_name Like 'SEARCHVAR' OR last_name Like 'SEARCHVAR') ORDER BY first_name ASC, last_name ASC
    List<Map> list = await _db.rawQuery(queryCat);
    return list.map((person) => Person.fromJson(person)).toList();
  }

  dispose() {
    _db.close();
  }
}
