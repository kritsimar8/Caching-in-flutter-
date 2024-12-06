import 'dart:convert';

import 'package:flutter_caching_data/controllers/local_database.dart';
import 'package:flutter_caching_data/models/models.dart';
import 'package:http/http.dart' as http;



class HackerNewsApi {
  static Future<bool> getLatestHackerNews() async {
    String url = "https://hn.algolia.com/api/v1/search_by_date?tags=story";

    try{
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      for(var dt in data["hits"]) {
        var news = HackerNews.fromJson(dt);

        LocalDatabase.insertNews(news);
        LocalDatabase.insertSavedTime(0);
      }
      return true;
    }else{
      print('error in fetching ${response.statusCode}');
      return false;
    }
    }catch(e){
      print(e);
      return false;
    }

  }
}