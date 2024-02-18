import 'dart:developer';
import 'dart:io';

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
    return true;
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
          "id INTEGER PRIMARY KEY,"
          "date TEXT,"
          "type TEXT,"
          "duration REAL,"
          "calories REAL,"
          "category TEXT,"
          "description TEXT,"
          "v INTEGER"
          ");");
      await db!.execute("CREATE TABLE Dates ("
          "date TEXT"
          ");");
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

  Future<List<String>> findDates() async {
    var maps = await db!.query('Dates');
    return maps.map<String>((m) => m['date'] as String).toList();
  }

  persistDates(List<String> dates) async {
    await db!.delete('Dates');
    await Future.wait(dates.map((d) async {
      log('Inserting date $d');
      await db!.insert('Dates', {'date': d});
    }));
  }

  Future<List<FitnessActivity>> findAllForDate(String date) async {
    var maps =
        await db!.query('TripLegs', where: 'date = ?', whereArgs: [date]);
    return maps.map<FitnessActivity>(FitnessActivity.fromMap).toList();
  }

  insertOne(FitnessActivity leg) async {
    await db!.insert('TripLegs', leg.toMap());
  }

  Future<bool> tryInsertOne(FitnessActivity leg) async {
    final existing =
        await db!.query('TripLegs', where: 'id = ?', whereArgs: [leg.id]);
    log('train num ${leg.id} count ${existing.length}');
    if (existing.isEmpty) {
      await insertOne(leg);
      return true;
    }
    return false;
  }

  updateOne(int id, FitnessActivity leg) async {
    await db!.update('TripLegs', leg.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  deleteOne(int id) async {
    await db!.delete('TripLegs', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> tryDeleteOne(int id) async {
    return await db!.delete('TripLegs', where: 'id = ?', whereArgs: [id]) != 0;
  }

  resetWithNewList(List<FitnessActivity> legs) async {
    log('Resetting db with ${legs.length} entities');
    await db!.delete('TripLegs');
    await Future.wait(legs.map((leg) async {
      final existing =
          await db!.query('TripLegs', where: 'id = ?', whereArgs: [leg.id]);
      log('id ${leg.id} count ${existing.length}');
      if (existing.isEmpty) {
        await insertOne(leg);
      } else {
        final existingLegs = existing.map(FitnessActivity.fromMap).toList();
        await updateOne(existingLegs[0].id, leg);
      }
    }));
  }
}
