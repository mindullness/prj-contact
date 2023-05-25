import 'dart:async';

import 'package:flutter_projects/prj-contact/enum/app_const.dart';
import 'package:flutter_projects/prj-contact/model/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DBRepository {
  Database? _database;
  static final DBRepository instance = DBRepository._init();
  DBRepository._init();

  Future<Database> get getDb async {
    // _database!.execute("delete from ${AppConst.tableName}");
    if (_database != null) return _database!;

    _database = await _initDB('contact.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    var context = p.Context(style: p.Style.platform);

    final dbPath = await getDatabasesPath();
    final path = context.join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database database, int version) async {
    await database.execute('''
    create table ${AppConst.tableName} (
      ${AppConst.contactId} integer primary key autoincrement,
      ${AppConst.contactName} text not null,
      ${AppConst.contactPhone} text
    )
''');
  }

  // CRUD
  FutureOr<int> insert({required Contact model}) async {
    try {
      final db = await getDb;
      final id = db.insert(AppConst.tableName, model.toMap());
      return id;
    } catch (e) {
      // print(e.toString());
      return 0;
    }
  }

  Future<List<Contact>> getAllContacts() async {
    final db = await instance.getDb;
    final result = await db
        .query(AppConst.tableName); // result = List<Map<String, dynamic>>
    return result.map((e) => Contact.fromJson(e)).toList();
  }

  Future<bool> deleteContact(int id) async {
    final db = await instance.getDb;
    final result = await db.delete(AppConst.tableName,
        where: '${AppConst.contactId} = ?', whereArgs: [id]);
    if (result != 0) {
      return true;
    }
    return false;
  }
}
