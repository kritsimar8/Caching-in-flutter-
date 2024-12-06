
import 'package:flutter_caching_data/models/models.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase{
  static Future<Database> createDatabase() async {
    return await openDatabase(
      "hacker_news.db",
      version: 1,
      onCreate: (db,version)async {
      await db.execute('CREATE TABLE news (id INTEGER PRIMARY KEY,title TEXT, url TEXT , author VARCHAR(255),updatedAt TEXT)');

      await db.execute('CREATE TABLE saved_time (page_no INTEGER PRIMARY KEY, lastSavedTime DATETIME)');


      }
    );
  }

  static Future insertNews(HackerNews hackerNews) async {
    var db = await createDatabase();

    return await db.insert("news", {
      "id": hackerNews.id,
      "title":hackerNews.title,
      "url":hackerNews.url,
      "author":hackerNews.author,
      "updatedAt":hackerNews.updatedAt
    },
    conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future <List<Map<String,dynamic>>> getNews() async {
    var db = await createDatabase();
    return await db.query(
      "news", 
      orderBy: 'updatedAt DESC',
      limit: 10
    );
  }

  static Future<List<Map<String,dynamic>>> getMoreNews(int lastNo) async{
    var db = await createDatabase();
    return await db.query("news",
    orderBy: 'updatedAt DESC', limit: 20, offset: lastNo
    );
  }

  static Future<int?> getNewsCount() async {
    var db = await createDatabase();
    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM news"));
  }

  static Future deleteAllNews() async {
    var db = await createDatabase();
    return await db.delete("news");
  }

  static Future insertSavedTime(int pageNo) async {
    var db = await createDatabase();
    return await db.insert("saved_time",{"page_no":pageNo, "lastSavedTime": DateTime.now().toString()},
    conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<List<Map<String,dynamic>>> getSaveTime() async {
    var db = await createDatabase();
    var data = await db.query("saved_time");
    print(data);
    return data;
  }

  static Future deleteSavedTime() async {
    var db = await createDatabase();

    return await db.delete("saved_time");
  }


}