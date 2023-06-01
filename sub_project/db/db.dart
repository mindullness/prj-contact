import 'dart:async';

import 'package:pretest_prj/constant/const_contact.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show Context, Style;

class DB {
  static Database? _database;

  static final DB _instance = DB._internal();
  DB._internal();
  factory DB() {
    return _instance;
  }
  Future<Database> get db async {
    // _database!.delete(ConstContact.tblContact);
    return _database ?? await _initDb(ConstContact.contactDb);
  }

  Future<Database> _initDb(String dbNamePath) async {
    var context = Context(style: Style.platform);

    final dbPath = await getDatabasesPath();
    final path = context.join(dbPath, dbNamePath);

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  FutureOr<void> _createDb(Database db, int version) async {
    String sql = '''CREATE TABLE ${ConstContact.tblContact} (
      ${ConstContact.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${ConstContact.name} TEXT NOT NULL,
      ${ConstContact.phone} TEXT
    )''';
    return db.execute(sql);
  }
}
