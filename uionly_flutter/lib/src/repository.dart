import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uionly_flutter/trip_legs/trip_leg.dart';

class Repository {
  static Repository? _repo;
  static Repository get instance {
    _repo ??= Repository();
    return _repo!;
  }

  bool get isInited {
    return db != null;
  }

  bool get resetDb {
    return false;
  }

  Database? db;

  init() async {
    log("Repo init start");
    final dbsPath = await getDatabasesPath();
    final dbPath = join(dbsPath, 'db.sqlite');
    if (resetDb) {
      await deleteDatabase(dbPath);
    }
    db = await openDatabase(dbPath);

    if (resetDb) {
      await db!.execute("CREATE TABLE TripLegs ("
          // "id INTEGER PRIMARY KEY,"
          "trainNum TEXT,"
          "depStation TEXT,"
          "arrStation TEXT,"
          "depTime TEXT,"
          "arrTime TEXT,"
          "observations TEXT"
          ");");

      await db!.execute("INSERT INTO TripLegs VALUES"
          "(\"IR1765\", \"Cluj-Napoca\", \"Iasi\", \"12:34\", \"23:45\", \"i hate this\"),"
          "(\"R1234\", \"Unirea hc\", \"Bucuresti Nord (ew)\", \"01:23\", \"04:11\", \"BLEH BUCURESTI\")"
          ";");
    }

    log("Repo init end");
  }

  static Future<T?> tryDatabaseOp<T>(
      BuildContext context, Future<T> Function() f,
      {bool exitOnFail = false,
      String message = "Couldn't do the db operation"}) async {
    T? ret;
    try {
      ret = await f();
    } on Exception catch (e) {
      if (!context.mounted) rethrow;
      log(e.toString());
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: const Text("The thing crashed"),
                  content: Text(
                      "$message, sorry.\n\nSee the console for more info.\nIf you're not a dev, ask a dev to look at the console for more info."),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          if (exitOnFail) exit(0);
                          Navigator.pop(ctx);
                        },
                        child: const Text("ok :(")),
                  ]));
    }
    return ret;
  }

  /*
   * TODO: READ ME
   * HELLO FUTURE ME
   * PLEASE ASK THE PROF
   * IF HE'D LIKE ME TO ATTEND
   * HIS DOCTORATE THESIS .. THING
   *
   * THANKS
   */

  findAll() async {
    var maps = await db!.query('TripLegs');
    return maps.map(TripLeg.fromMap);
  }

  insertOne(TripLeg leg) async {
    await db!.insert('TripLegs', leg.toMap());
  }

  updateOne(String trainNum, TripLeg leg) async {
    await db!.update('TripLegs', leg.toMap(),
        where: 'trainNum = ?', whereArgs: [trainNum]);
  }

  deleteOne(String trainNum) async {
    await db!.delete('TripLegs', where: 'trainNum = ?', whereArgs: [trainNum]);
  }
}
