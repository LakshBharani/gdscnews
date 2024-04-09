import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    // Get the device's directory for storing the database.
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "bookmarked_news.db");

    // Open/create the database at a given path
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    // Create tables
    await db.execute(
        "CREATE TABLE BookmarkedNews(id INTEGER PRIMARY KEY, title TEXT, url TEXT, score INTEGER, descendants INTEGER, time INTEGER, by TEXT, type TEXT, deleted INTEGER, dead INTEGER, parent INTEGER, poll INTEGER, kids TEXT, parts TEXT, descendantsList TEXT, timeAgo TEXT, bookmarked INTEGER DEFAULT 0)");
  }

  Future<int> saveNews(Map<String, dynamic> news) async {
    var dbClient = await db;
    int res = await dbClient.insert("BookmarkedNews", news);
    return res;
  }

  Future<List<Map<String, dynamic>>> getBookmarkedNews() async {
    var dbClient = await db;
    List<Map<String, dynamic>> res = await dbClient.query("BookmarkedNews");
    return res;
  }

  Future<int> deleteNews(int id) async {
    var dbClient = await db;
    int res = await dbClient
        .delete("BookmarkedNews", where: "id = ?", whereArgs: [id]);
    return res;
  }

  // clear db
  Future<int> clearDb() async {
    var dbClient = await db;
    int res = await dbClient.delete("BookmarkedNews");
    return res;
  }
}
