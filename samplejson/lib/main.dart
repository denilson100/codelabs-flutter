import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MaterialApp(
  home: new HomePage(),
));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

//  final String url = "https://swapi.co/api/people";
  final String url = "https://jsonplaceholder.typicode.com/posts";
  List data;

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http.get(
      Uri.encodeFull(url),
      headers: {"Accept": "application/json"}
    );
//    print(data[1]["body"]);

    setState((){
//      var convertDataToJson = JSON.decode(response.body);
//      data = convertDataToJson['results'];
        data = JSON.decode(response.body);
    });

    return "Success";

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Retrive Json via HTTP Get"),
      ),
      body: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: new Text(data[index]["title"]),
            );
          },
      ),
    );
  }

}



