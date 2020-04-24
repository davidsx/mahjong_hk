import 'package:sqflite/sqflite.dart';

abstract class DatabaseInterface {
  Future onCreate(Database db, int version);

  Future onConfiguration(Database db) => Future.value();

  Future onOpen(Database db) => Future.value();

  Future onUpgrade(Database db, int oldVer, int newVer) => Future.value();

  Future onDowngrade(Database db, int oldVer, int newVer) => Future.value();
}
