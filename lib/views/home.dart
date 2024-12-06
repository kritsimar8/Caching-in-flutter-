import 'package:flutter/material.dart';
import 'package:flutter_caching_data/controllers/fetch_api.dart';
import 'package:flutter_caching_data/controllers/local_database.dart';
import 'package:flutter_caching_data/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<HackerNews> latestNews = [];
  bool isLoading = true;
  List<Map<String,dynamic>> savedTime =[];

  getLastsavedTime() async {
    var time = await LocalDatabase.getSaveTime();
    setState(() {
      savedTime= time;
    });
  }



  firstPageNews()async {
    int count = await LocalDatabase.getNewsCount() ?? 0;
    print("No. of news saved ${count}");
    DateTime firstPageSavedTime = DateTime.parse(savedTime[0]["lastSavedTime"] ?? "2000-01-01");

    print(firstPageSavedTime);

    DateTime currentTime = DateTime.now();

    Duration difference = currentTime.difference(firstPageSavedTime);
    if (difference.inMinutes > 2 || count ==0){
      print("fetching the api");
      var isApifetching = await HackerNewsApi.getLatestHackerNews();
      if(isApifetching){
        getNews();
      }
    }else{
      print("data from local database");
      getNews();
    }
  }

  getNews() async {
    var news = await LocalDatabase.getNews();
    setState(() {
      latestNews = news.map((e)=> HackerNews.fromJson(e)).toList();
      isLoading = false;
    });
  }

  @override 
  void initState() {
    getLastsavedTime();
    firstPageNews();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hacker News"),
        centerTitle: true,
      ),
      body: isLoading? Center(child: CircularProgressIndicator(),):
      ListView.builder(
        itemCount: latestNews.length,
        itemBuilder: (context,index){
          return ListTile(
            leading: Text("${index+1}."),
            title: Text(latestNews[index].title),
            subtitle: Text("By :-${latestNews[index].author}"),
            trailing: IconButton(onPressed: (){
              _launchUrl(latestNews[index].url);
            }, icon: Icon(Icons.open_in_new)),
          );
        }),
      floatingActionButton: Padding(padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
         FloatingActionButton(
          onPressed: (){
            
            firstPageNews();
            setState(() {
              isLoading = true;
              
            });
          },
          child: Icon(Icons.refresh),
        ),
        SizedBox(width: 20,),
           FloatingActionButton(
          onPressed: (){
            LocalDatabase.deleteAllNews();
            setState(() {
              latestNews =[];
            });
          },
          child: Icon(Icons.delete),
        ),
        ],
      ),),
    );
  }
}
Future<void> _launchUrl(String _url) async{
  if(!await launchUrl(Uri.parse(_url))){
    throw Exception('could not launch $_url');
  }
}