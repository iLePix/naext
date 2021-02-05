import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:naext/api/token_dto.dart';




class DatabaseService {
  static final DatabaseService _instance = new DatabaseService.internal();
  factory DatabaseService() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseService.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "user.db");
    /*String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, "main.db");*/
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);     //inits DB and runs onCreate Function
    return theDb;
  }


  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE user (id INTEGER PRIMARY KEY, accessToken TEXT, accessToken_expiry INTEGER, refreshToken TEXT)"); //Creates Database
    print("Created table");
  }

  Future<List> getSessionData() async {
    var dbClient = await db;
    List<Map> tokenDetails = await dbClient.rawQuery('SELECT * FROM user');   //returns all User Data as Map
    return tokenDetails;
  }

  Future<bool> saveSession(TokenDTO tokenDTO) async {
    print("Database.saveSession => Added new Token Data");
    var dbClient = await db;
    int res = await dbClient.insert("user", tokenDTO.toJson());  //returns true if User with [uid] has been deleted, else returns false
    //int res = await dbClient.insert("token", {"accessToken": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJsb2dpbmZ1bmt0aW9uaWVydCIsImlhdCI6MTU5ODcxNDk5MCwiZXhwIjoxNTk4NzQ0OTkwfQ.X3uN6HAyetpn20t7WO2MTwCXQQDO-SMP3Fq-le0HjYm54BNlAUvsc4Zsw-yX_9cZWVCk4N0R0VE9Pbg0B5IBkg", "refreshToken": "f10693dd-61c8-457f-b813-cb1787ad5e9d", "accessToken_expiry": 1598744990});
    return res >  0;
  }

  Future<bool> deleteSession() async {
    var dbClient = await db;
    int res = await dbClient.delete("user");  //returns User Data if u_loggedin = true, if there is no u_loggedin = true returns false
    return res >  0;
  }


}