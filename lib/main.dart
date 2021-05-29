import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(FetchDataApp());

Future<List<Album>> fetchData() async {
  final response =
      await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums'));

  final jsonData = json.decode(response.body) as List<dynamic>;

  List<Album> data = jsonData.map((json) => Album.fromJson(json)).toList();

  return data;
}

class Album {
  int userId;
  int id;
  String title;

  Album({required this.id, required this.userId, required this.title});
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        id: json['id'] as int,
        userId: json['userId'] as int,
        title: json['title'] as String);
  }
}

class FetchDataApp extends StatefulWidget {
  const FetchDataApp({
    Key? key,
  }) : super(key: key);

  @override
  _FetchDataAppState createState() => _FetchDataAppState();
}

class _FetchDataAppState extends State<FetchDataApp> {
  late Future<List<Album>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Fetching Data from API'),
          ),
        ),
        body: FutureBuilder<List<Album>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data![index].title),
                        Text(snapshot.data![index].userId.toString()),
                        Text(snapshot.data![index].id.toString())
                      ],
                    ),
                  );
                }
                      itemCount:snapshot.data!.length
                   );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}


