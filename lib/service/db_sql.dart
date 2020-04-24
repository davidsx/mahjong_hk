import 'dart:io';

import 'package:mahjong/models/base.dart';
import 'package:mahjong/service/db_interface.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService dbService = DatabaseService._();

  bool checkInit = false;

  Database _db;

  int get _version => 1;

  String get _dbName => "mj.db";

  Future<void> dispose() async {
    await _db.close();
    _db = null;
  }

  Future<void> init() async {
    print("init database");
    if (_db != null) {
      return;
    }

    try {
      // String _dbPath = await getDatabasesPath();
      Directory _dbDir = await getApplicationDocumentsDirectory();
      String _path = join(_dbDir.path, _dbName);
      // await deleteDatabase(_path);
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: onCreate,
      ).then((db) {
        print("init complete");
        checkInit = true;
        return db;
      });
    } catch (ex) {
      print(ex);
    }
  }

  Future<Database> get db async {
    if (_db != null) return _db;
    await init();
    return _db;
  }

  void onCreate(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS MJtable');
    await db.execute('DROP TABLE IF EXISTS MJround');
    await db.execute('''
      CREATE TABLE MJtable (
        id TEXT PRIMARY KEY NOT NULL, 
        players TEXT, 
        starter INTEGER,
        dealer INTEGER,
        wind TEXT,
        stage INTEGER,
        gameEnd INTEGER,
        gameStart INTEGER,
        ruleIndex INTEGER,
        ruleAmount INTEGER,
        lastUpdated TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE MJround (
        id TEXT PRIMARY KEY NOT NULL, 
        tableID TEXT,
        winner TEXT,
        loser TEXT,
        players TEXT,
        method INTEGER,
        ruleIndex INTEGER,
        winning INTEGER,
        losing INTEGER,
        round TEXT,
        status INTEGER,
        FOREIGN KEY (tableID) REFERENCES MJtable (id) ON DELETE NO ACTION ON UPDATE NO ACTION
      )
      ''');
  }

  Future<List<Map<String, dynamic>>> query(String table) async =>
      (await db).query(table);

  Future<List<Map<String, dynamic>>> queryID(String table, String id) async =>
      (await db).query(table, where: 'id = ?', whereArgs: [id]);

  Future<List<Map<String, dynamic>>> queryWhere(
          String table, String column, String arg) async =>
      (await db).query(table, where: '$column = ?', whereArgs: [arg]);

  Future<int> insert(String table, Model model) async {
    print("-----------insert-----------");
    print(model.toMap());
    return (await db).insert(table, model.toMap());
  }

  Future<int> update(String table, Model model) async {
    print("-----------update-----------");
    print(model.toMap());
    return (await db)
        .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);
  }

  Future<int> delete(String table, Model model) async =>
      (await db).delete(table, where: 'id = ?', whereArgs: [model.id]);
}
