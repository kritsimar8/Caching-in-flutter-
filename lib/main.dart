import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_caching_data/controllers/local_database.dart';
import 'package:flutter_caching_data/views/home.dart';
import 'package:url_launcher/url_launcher.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase.createDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
    
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}


class ImageCache extends StatefulWidget {
  const ImageCache({super.key});

  @override
  State<ImageCache> createState() => _ImageCacheState();
}

  const String imagePath = "https://images.unsplash.com/photo-1732719812776-c043e861faf8?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";



class _ImageCacheState extends State<ImageCache> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter cache image',
        ),
      ),
      body: content(),
    );
  }
  Widget content(){
    return  Center(
      child: Column(
        children: [
         const Text(
            'Cache Network Image',
            style: TextStyle(
              fontSize: 30
            ),
          ),
          SizedBox(
            height: 80,
            child: CachedNetworkImage(imageUrl: imagePath, placeholder: (context,url)=> const CircularProgressIndicator(),
            errorWidget: (context,url,error)=> const Icon(Icons.error),),
          ),
          SizedBox(height: 50,),
          const Text(
            'Network Image',
            style: TextStyle(
              fontSize: 30
            ),
          ),
          SizedBox(
            height: 80,
            child: Image.network(imagePath))
        ],
      ),
    );
  }
}

