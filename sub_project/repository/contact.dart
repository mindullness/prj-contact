import 'package:pretest_prj/constant/const_contact.dart';
import 'package:pretest_prj/db/db.dart';
import 'package:sqflite/sqflite.dart';

import '../model/contact.dart';

class ContactRepository {
  static Future<List<Contact>> getContacts(String text) async {
    final dB = await DB().db;
    final result = await dB.query(
      ConstContact.tblContact,
      where: '${ConstContact.name} LIKE ?',
      whereArgs: ['%$text%'],
    );
    return result.map((item) => Contact.fromMap(item)).toList();
  }

  static Future<int> insert(Contact contact) async {
    try {
      final dB = await DB().db;
      Map<String, dynamic> obj = contact.toMap();
      final result = await dB.insert(
        ConstContact.tblContact, obj,
        // contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      return 0;
    }
  }

  static Future<int> update(Contact contact) async {
    try {
      final dB = await DB().db;
      return dB.update(
        ConstContact.tblContact,
        contact.toMap(),
        where: "${ConstContact.id} = ?",
        whereArgs: [contact.id],
      );
    } catch (e) {
      return 0;
    }
  }

  static Future<bool> delete(int id) async {
    try {
      final dB = await DB().db;
      return await dB.delete(
                ConstContact.tblContact,
                where: "${ConstContact.id} = ?",
                whereArgs: [id],
              ) >
              0
          ? true
          : false;
    } catch (e) {
      return false;
    }
  }
}
