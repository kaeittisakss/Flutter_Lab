import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Dbhelper {
  static const dbname = 'mydb.db';
  static const dbversion = 1;
  static const tablename = 'book';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnPrice = 'price';

  Dbhelper._privateConstructor();
  static final Dbhelper instance = Dbhelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbname);
    return await openDatabase(path, version: dbversion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tablename (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnPrice INTEGER NOT NULL
    )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(tablename, row);
  }

  Future<List<Map<String, dynamic>>> queryall() async {
    Database? db = await instance.database;
    return await db!.query(tablename);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(tablename, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(tablename, where: '$columnId = ?', whereArgs: [id]);
  }
}

//how to use this class Bdhelper
//void main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//  Dbhelper helper = Dbhelper.instance;
//  await helper.database;
//  runApp(const MyApp());
//}
