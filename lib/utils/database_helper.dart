import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/memo_model.dart';

// declare table name
final String table_name = 'memoTable';

class DatabaseHelper{
  // create Database helper global key
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper()=>_instance;

  // Check if db !=  null means it ready else wait till it's ready
  static Database _db;
  Future<Database> get db async{
    if(_db!=null){
      return _db;
    }
    else{
      _db = await initDb();
      return _db;
    }
  }

  DatabaseHelper.internal();

  // Initialize database
  initDb() async{
    // create database file
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,"bits1_database.db");
    var ourDb = await openDatabase(path,version: 1,onCreate: _onCreate);
    return ourDb;
  }

  // Above we have declared table name now creating it
  // Note : Model parameter and table column name must be same.
  void _onCreate(Database db,int newVersion) async{
    await db.execute(
        "CREATE TABLE $table_name('id' INTEGER PRIMARY KEY,'title' TEXT,'input' TEXT , 'key' TEXT)"
    );
  }

  // Save our memo to database
  Future<int> saveMemo (MemoModel memo) async{
    var dbClient = await db;
    var res = await dbClient.insert("$table_name", memo.toMap());
    return res;
  }

  // Get all our memo from database in Array
  Future<List> getAllMemo() async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table_name ");
    return result.toList();
  }

  // Get count will help to build list view
  Future<int> getCount() async{
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $table_name")
    );
  }

  // Get our memo to display on next page or update it
  Future<MemoModel> getMemo(int id) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table_name WHERE id=$id");
    if(result.length == 0) return null;
    return new MemoModel.fromMap(result.first);
  }

  // Update the memo
  Future<int> updateMemo(MemoModel memo) async{
    var dbClient = await db;
    print("Recieved id from update : ${memo.id} ");
    return await dbClient.update(table_name, memo.toMap(), where: "id= ?", whereArgs: [memo.id]);
  }

  // Delete memo
  Future<int> deleteMemo(int id) async{
    var dbClient = await db;
    return await dbClient.delete(table_name, where: "id= ?", whereArgs: [id]);
  }

  // Finally close the database
  Future close() async{
    var dbClient= await db;
    dbClient.close();
  }


}// End of class