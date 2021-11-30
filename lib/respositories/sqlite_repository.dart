import 'dart:developer' as developer;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:utweat/models/content_model.dart';
import 'package:utweat/respositories/abstracts/database_repository.dart';

class SQLiteRepository implements DatabaseRepository {
  late final Database _database;

  Future<int> get _maxId async =>
      (await _database.rawQuery('SELECT MAX(uid) FROM contents'))
          .first["MAX(uid)"] as int;

  @override
  Future<void> intializeDatabase(String dbName) async {
    String pathDatabase = join(await getDatabasesPath(), dbName);

    developer.log(pathDatabase);

    _database = await openDatabase(
      pathDatabase,
      onCreate: (db, version) async {
        developer.log("Install database");

        await db.execute("DROP TABLE IF EXISTS accounts");
        await db.execute("DROP TABLE IF EXISTS contents");
        await db.execute("DROP TABLE IF EXISTS contents_used");

        await db.execute(
          "CREATE TABLE IF NOT EXISTS accounts(uid INTEGER PRIMARY KEY, name TEXT);",
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS contents(uid INTEGER PRIMARY KEY, description TEXT, content TEXT, possibilities INT, account_uid INT);",
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS contents_used(uid INTEGER PRIMARY KEY, content TEXT, content_uid INT);",
        );

        await db.insert(
          "accounts",
          {
            "uid": 1,
            "name": "Default",
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      },
      version: 1,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> all(String tableName) async =>
      await _database.query(tableName);

  @override
  Future<void> insert(
    ContentModel contentModel,
  ) async {
    Map<String, dynamic> content = contentModel.toJson();

    content.remove("contents");

    try {
      content["uid"] = (await _maxId) + 1;
    } catch (e) {
      content["uid"] = 1;
    }

    await _database.insert(
      "contents",
      content,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteById(String tableName, String uid) async {
    await _database.delete(
      tableName,
      where: "uid = ?",
      whereArgs: [
        uid,
      ],
    );
  }

  @override
  Future<Map<String, dynamic>> getById(String uid) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      "contents",
      where: "uid = ?",
      whereArgs: [
        uid,
      ],
    );

    return maps.isNotEmpty ? maps.first : {};
  }

  @override
  Future<void> addNewContentsUsed(Map<String, dynamic> content) async {
    await _database.insert(
      "contents_used",
      content,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> allByJoinId(
    String tableName,
    String joinId,
  ) async =>
      await _database.query(
        tableName,
        where: "content_uid = ?",
        whereArgs: [
          joinId,
        ],
      );
}
