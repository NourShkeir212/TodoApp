import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';

class DbHelper{
  static Database? _db;
  static final int _version =1;

  static final String _tableName ='task';

  static Future<void> initDb()async {
    if(_db !=null){
      return ;
    }
    try{
      String _path =await getDatabasesPath() + 'task.db';
      _db =await openDatabase(
        _path,
        version: _version,
        onCreate: (db,version){
          print('creating a new one');
          return db.execute(
          "CREATE TABLE $_tableName("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "title STRING, note TEXT, date STRING,"
              "startTime STRING, endTime STRING,"
              "remind INTEGER , repeat STRING,"
              "color INTEGER,"
              "isCompleted INTEGER)",
          );
        },
      );
    } catch (e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task? task) async {
    if (kDebugMode) {
      print('insert Function called');
    }
    return await _db?.insert(_tableName, task!.toJson())??1;
  }

  static Future<List<Map<String,dynamic>>> query() async {
    if (kDebugMode) {
      print('query function called');
    }
    return await _db!.query(_tableName);
  }

  static delete(Task task)async{
  return await _db?.delete(_tableName,where: 'id=?',whereArgs: [task.id]);
  }

  static update(int id)async{
  return await _db!.rawUpdate('''
    UPDATE task
    SET isCompleted = ?
    WHERE id =?
    ''',[1,id]);
  }
}